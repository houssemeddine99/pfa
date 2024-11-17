<?php

namespace App\Traits;

use Illuminate\Support\Facades\Validator;

trait CustomPasswordValidation
{
    /**
     * Get the password validation rules.
     *
     * @return array
     */
    protected function passwordRules()
    {
        return [
            'required',
            'string',
            'min:8',
            'confirmed',
            'regex:/[a-z]/',      // must contain at least one lowercase letter
            'regex:/[A-Z]/',      // must contain at least one uppercase letter
            'regex:/[0-9]/',      // must contain at least one digit
            'regex:/[@$!%*#?&]/', // must contain a special character
        ];
    }

    /**
     * Override the validator method from RegistersUsers trait
     */
    protected function validator(array $data)
    {
        return Validator::make($data, [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'email', 'max:255', 'unique:users'],
            'password' => $this->passwordRules(),
        ], [
            'password.regex' => 'The password must contain at least one uppercase letter, one lowercase letter, one number, and one special character.',
        ]);
    }
}