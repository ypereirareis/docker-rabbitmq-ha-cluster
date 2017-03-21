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

//        $propertyKeys = [
//            'content_type', 'delivery_mode', 'content_encoding', 'type', 'timestamp', 'priority', 'expiration',
//            'app_id', 'message_id', 'reply_to', 'correlation_id', 'user_id', 'cluster_id', 'channel', 'consumer_tag',
//            'delivery_tag', 'redelivered', 'exchange', 'routing_key',
//        ];

        $message = new Message('"My first message with the awesome swarrot lib :)"', ['delivery_mode' => 2]);
        $messagePublisher = $this->getContainer()->get('swarrot.publisher');

        $i = 0;
        while(true) {
            $messagePublisher->publish('my_publisher', $message);
            usleep(5000);
            ++$i;
            if ($i === 10) {
                break;
            }
        }
    }
}
