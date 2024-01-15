<?php

$app->get('/', '\App\Landing\LandingController:home')->add($auth);
$app->get('/calendar', '\App\Landing\LandingController:calendar')->add($auth);
$app->get('/bgevents', '\App\Landing\LandingController:bgevents')->add($auth);

$app->get('/api/v1/book1', 'App\Landing\LandingController:getBook1');
$app->get('/api/v1/book2', 'App\Landing\LandingController:getBook2');