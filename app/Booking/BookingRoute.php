<?php

$app->get('/check_room', 'App\Booking\BookingController:checkRoom')->add($auth);
$app->get('/booking_report', '\App\Booking\BookingController:bookingReport');

$app->get('/api/v1/book', 'App\Booking\BookingController:getBook');
$app->get('/book/weekly', 'App\Booking\BookingController:weekly');
$app->get('/book/timein', 'App\Booking\BookingController:timein');
$app->get('/book/timeout', 'App\Booking\BookingController:timeout');

$app->post('/booking/create', 'App\Booking\BookingController:create');
$app->post('/booking/update', 'App\Booking\BookingController:update');
$app->post('/booking/daletefood', 'App\Booking\BookingController:daletefood');
$app->post('/booking/cancel', 'App\Booking\BookingController:cancel');
$app->post('/booking/cancel_id', 'App\Booking\BookingController:cancel_id');