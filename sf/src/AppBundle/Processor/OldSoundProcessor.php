<?php
namespace AppBundle\Processor;

use OldSound\RabbitMqBundle\RabbitMq\ConsumerInterface;
use PhpAmqpLib\Message\AMQPMessage;


class OldSoundProcessor implements ConsumerInterface
{
    public function execute(AMQPMessage $msg)
    {
        // TODO: Implement execute() method.
        return false;
    }

}