<?php
namespace AppBundle\Processor;

use Swarrot\Broker\Message;
use Swarrot\Processor\ProcessorInterface;

class TestConsumeQuicklyProcessor implements ProcessorInterface
{
    public function process(Message $message, array $options)
    {
        //echo $message->getBody()."\n";
    }
}