<?php

namespace AppBundle\Command;

use AppBundle\Elasticsearch\ElasticsearchHelper;
use AppBundle\Mysql\MysqlHelper;
use Elastica\Type;
use Swarrot\Broker\Message;
use Symfony\Bundle\FrameworkBundle\Command\ContainerAwareCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

/**
 * Class TestCommand
 */
class TestCommand extends ContainerAwareCommand
{

    /**
     * {@inheritdoc}
     */
    protected function configure()
    {
        $this->setName('rb:test');
    }


    /**
     * {@inheritdoc}
     */
    protected function execute(InputInterface $input, OutputInterface $output)
    {

        $io = new SymfonyStyle($input, $output);

        $message = new Message('"My first message with the awesome swarrot lib :)"', ['delivery_mode' => 2]);
        $messagePublisher = $this->getContainer()->get('swarrot.publisher');

        $i = 0;
        $bulk = 100;
        $connectionRetry = 0;
        $exceptionRetry = 0;
        while(true) {
            try {
                $publisherString = 'my_publisher_1';
                $this->getContainer()->get('m6_statsd')->increment('producer.bundle');
                $this->getContainer()->get('m6_statsd')->timing('producer.memory', memory_get_usage(true)/1024/1024);
                echo (memory_get_usage(true)/1024/1024)."\n";
                $messagePublisher->publish($publisherString, $message);
            } catch (\AMQPConnectionException $ex) {
                if ($connectionRetry++ < 5) {
                    $io->note('Trying to reconnect => '.$connectionRetry);
                    sleep(2);
                    continue;
                }
                $io->warning("Exit with error: ".$ex->getMessage());
                $this->getContainer()->get('m6_statsd')->increment('producer.exception');
                break;
            } catch (\Exception $exception) {
                if ($exceptionRetry++ < 5) {
                    $io->note('Skipping exception => '.$exceptionRetry);
                    sleep(2);
                    continue;
                }
                $io->warning("Exit with error: ".$exception->getMessage());
                $this->getContainer()->get('m6_statsd')->increment('producer.exception');
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
