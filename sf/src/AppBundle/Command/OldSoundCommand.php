<?php

namespace AppBundle\Command;

use AppBundle\Elasticsearch\ElasticsearchHelper;
use AppBundle\Mysql\MysqlHelper;
use Elastica\Type;
use PhpAmqpLib\Message\AMQPMessage;
use Swarrot\Broker\Message;
use Symfony\Bundle\FrameworkBundle\Command\ContainerAwareCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

/**
 * Class OldSoundCommand
 */
class OldSoundCommand extends ContainerAwareCommand
{

    /**
     * {@inheritdoc}
     */
    protected function configure()
    {
        $this->setName('rb:oldsound_produce');
    }


    /**
     * {@inheritdoc}
     */
    protected function execute(InputInterface $input, OutputInterface $output)
    {

        $io = new SymfonyStyle($input, $output);

        $messagePublisher = $this->getContainer()
            ->get('old_sound_rabbit_mq.oldsound_producer');
        $messagePublisher->setContentType('application/json');
        $messagePublisher->setDeliveryMode(AMQPMessage::DELIVERY_MODE_PERSISTENT);

        $i = 0;
        $bulk = 100;
        $connectionRetry = 0;
        $exceptionRetry = 0;
        while(true) {
            try {
                $messagePublisher->publish(serialize("My first message with the awesome swarrot lib :)"));
            } catch (\AMQPConnectionException $ex) {
                if ($connectionRetry++ < 5) {
                    $io->note('Trying to reconnect => '.$connectionRetry);
                    sleep(2);
                    continue;
                }
                $io->warning("Exit with error: ".$ex->getMessage());
                break;
            } catch (\Exception $exception) {
                if ($exceptionRetry++ < 5) {
                    $io->note('Skipping exception => '.$exceptionRetry);
                    sleep(2);
                    continue;
                }
                $io->warning("Exit with error: ".$exception->getMessage());
                break;
            }

            usleep(10000);
            ++$i;
            if ($i === $bulk) {
                $io->writeln('Process ' .getmypid() . ': '.$bulk.' more messages added');
                break;
            }
        }
    }
}
