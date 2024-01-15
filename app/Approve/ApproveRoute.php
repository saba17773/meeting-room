<?php
$app->get('/mg_approve_user/remark', '\App\Approve\ApproveController:remark');
$app->get('/mg_approve_user/remark/food', '\App\Approve\ApproveController:remark_food');
$app->get('/mg_approve_user/remark/layout', '\App\Approve\ApproveController:remark_layout');
$app->get('/mg_approve_user/remark/support', '\App\Approve\ApproveController:remark_support');
$app->get('/mg_approve', '\App\Approve\ApproveController:mg_approve');
$app->get('/mg_approve_user', '\App\Approve\ApproveController:mg_approve_user');
$app->get('/mg_approve_hr', '\App\Approve\ApproveController:mg_approve_hr');
$app->get('/complete_hr', '\App\Approve\ApproveController:complete_hr');
$app->post('/booking/approve', '\App\Approve\ApproveController:approve');
$app->post('/booking/admin/approve', '\App\Approve\ApproveController:admin_approve');