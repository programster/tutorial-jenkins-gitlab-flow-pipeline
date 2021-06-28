<?php

require_once(__DIR__ . '/../vendor/autoload.php');

$dotenv = new Symfony\Component\Dotenv\Dotenv();
$dotenv->overload(__DIR__ . '/../.env');

if (!isset($_ENV['SERVICE_NAME']))
{
    throw new Exception("Missing required SERVICE_NAME environement variable.");
}

print "The name of this service is: " . $_ENV['SERVICE_NAME'] . PHP_EOL;