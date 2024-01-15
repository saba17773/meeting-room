<?php

$app->get('/report', 'App\Report\ReportController:index');
$app->get('/report_room', 'App\Report\ReportController:report_room');
$app->get('/report_day', 'App\Report\ReportController:report_day');
$app->get('/report/load/day', 'App\Report\ReportController:load_day');