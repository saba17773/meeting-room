<?php
// Application middleware

// e.g: $app->add(new \Slim\Csrf\Guard);
$auth = function ($request, $response, $next) {
  if (isset($_SESSION["user_id"])) {
  	$response = $next($request, $response);
  } else {
  	return $response->withRedirect("/login");
  }
  return $response;
};