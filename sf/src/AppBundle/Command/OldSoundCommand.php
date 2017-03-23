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
        $publisherIdx = 1;
        while(true) {
            try {
                $publisherString = 'my_publisher_'.$publisherIdx;
                $messagePublisher->publish(serialize("My first message with the awesome swarrot lib :)"));
                $io->writeln("Writing with publisher ". $publisherString);
            } catch (\AMQPConnectionException $ex) {
                $publisherIdx = ($publisherIdx % 3) + 1;
                continue;
            }

            usleep(5000);
            ++$i;
            if ($i === 10) {
                break;
            }
        }
    }
}
