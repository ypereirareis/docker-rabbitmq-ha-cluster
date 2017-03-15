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

        $message = new Message('"My first message with the awesome swarrot lib :)"');
        $messagePublisher = $this->getContainer()->get('swarrot.publisher');

        while(true) {
            $messagePublisher->publish('my_publisher', $message);
            usleep(10000);
        }

        $io->title('TEST OK');
        $io->error('TEST OK');
        $io->caution('TEST OK');
        $io->block('TEST OK');
        $io->success('TEST OK');
        $pb = $io->createProgressBar(100);
        $pb->finish();

    }
}
