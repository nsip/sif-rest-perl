#!/usr/bin/perl
use REST::Client;

#options may be passed as well as set
$client = REST::Client->new({
		host    => 'https://example.com',
		cert    => '/path/to/ssl.crt',
		key     => '/path/to/ssl.key',
		ca      => '/path/to/ca.file',
		timeout => 10,
	});
$client->GET('/dir/file', {CustomHeader => 'Value'});

i
