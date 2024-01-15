<?php

namespace App\Company;

use App\Company\CompanyAPI;

class CompanyController
{
  public function getAll($request, $response, $args) {
    return $response->withJson((new CompanyAPI)->getAll());
  }
}