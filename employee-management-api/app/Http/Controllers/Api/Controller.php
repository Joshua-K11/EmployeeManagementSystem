<?php

namespace App\Http\Controllers;

use Illuminate\Routing\Controller as BaseController;

class Controller extends BaseController
{
    // Tambahkan fungsi umum jika diperlukan
    use AuthorizesRequests, DispatchesJobs, ValidatesRequests;
}
