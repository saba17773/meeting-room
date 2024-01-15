<?php

namespace Tests\Functional;

if ( !isset( $_SESSION ) ) $_SESSION = [];

class HomepageTest extends BaseTestCase
{
  public function testPostHomepageNotAllowed()
  {
    $response = $this->runApp('POST', '/', ['test']);

    $this->assertEquals(405, $response->getStatusCode());
    $this->assertContains('Method not allowed', (string)$response->getBody());
  }

  public function testPageTest()
  {
  	$response = $this->runApp('GET', '/test');
  	
    $this->assertEquals(200, $response->getStatusCode());
    $this->assertContains('test', (string)$response->getBody());
    $this->assertEquals('test', (string)$response->getBody());
  }
}