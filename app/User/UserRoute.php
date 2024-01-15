<?php

$app->get('/login', '\App\User\UserController:login');
// $app->post('/auth', '\App\User\UserController:auth')->add($container->get('csrf'));
$app->post('/auth', '\App\User\UserController:auth');
$app->get('/user', '\App\User\UserController:index')->add($auth);
$app->get('/user/profile', '\App\User\UserController:profile')->add($auth);
$app->get('/user/logout', '\App\User\UserController:logout');
$app->get('/user/resetpassword', '\App\User\UserController:resetpassword');
$app->get('/user/loadpermission', '\App\User\UserController:loadpermission');
$app->get('/user/loadstatus', '\App\User\UserController:loadstatus');
$app->get('/user/load', '\App\User\UserController:load');
$app->get('/user/load/emailhead', '\App\User\UserController:load_emailhead');
$app->get('/company/load', '\App\User\UserController:companyload');
$app->post('/user/update', '\App\User\UserController:update');
$app->post('/user/create', '\App\User\UserController:create');
$app->post('/user/update_email_head', '\App\User\UserController:update_email_head');
$app->post('/user/profile/update', '\App\User\UserController:profile_update');
$app->post('/user/changpassword', '\App\User\UserController:changpassword');
$app->get('/user/employee', '\App\User\UserController:employee');