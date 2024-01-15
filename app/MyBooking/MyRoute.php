<?php

$app->get('/mybooking', 'App\MyBooking\MyController:index')->add($auth);
$app->get('/mybooking/load', 'App\MyBooking\MyController:load');
$app->get('/mybooking/loadcancel', 'App\MyBooking\MyController:loadcancel');
$app->get('/load/food', 'App\MyBooking\MyController:loadfood');
$app->get('/load/dessert', 'App\MyBooking\MyController:loaddessert');
$app->get('/load/layout', 'App\MyBooking\MyController:loadlayout');
$app->get('/load/support', 'App\MyBooking\MyController:loadsupport');
$app->get('/load/mixs_approve', 'App\MyBooking\MyController:mixs_approve');
// $app->post('/tool/update', 'App\Tool\ToolController:update');