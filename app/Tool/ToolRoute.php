<?php

$app->get('/tool', 'App\Tool\ToolController:index');
$app->get('/load', 'App\Tool\ToolController:load');
$app->post('/tool/update', 'App\Tool\ToolController:update');
$app->post('/tool/create', 'App\Tool\ToolController:create');

$app->get('/remark', 'App\Tool\ToolController:remark');
$app->get('/loadremark', 'App\Tool\ToolController:loadremark');
$app->post('/remark/create', 'App\Tool\ToolController:remark_create');

$app->get('/load/remarktype', 'App\Tool\ToolController:loadremarktype');