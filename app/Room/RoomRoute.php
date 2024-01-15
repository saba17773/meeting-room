<?php
$app->get('/room', '\App\Room\RoomController:index');
$app->get('/room/load', '\App\Room\RoomController:load');
$app->get('/room/loadAll', '\App\Room\RoomController:loadAll');
$app->get('/room/loadcompany', '\App\Room\RoomController:loadcompany');
$app->get('/room/loadcompany_byper', '\App\Room\RoomController:loadcompany_byper');
$app->get('/room/loaddepartment', '\App\Room\RoomController:loaddepartment');
$app->get('/room/loadtoolAll', '\App\Room\RoomController:loadtoolAll');
$app->post('/room/create', '\App\Room\RoomController:create');
$app->post('/room/delete', '\App\Room\RoomController:delete');