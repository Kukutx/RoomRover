import { Component, inject } from '@angular/core';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatButtonModule } from '@angular/material/button';
import { Router } from '@angular/router';
import { FormControl, FormGroup, FormsModule, ReactiveFormsModule, Validators } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { HttpClient } from '@angular/common/http';


@Component({
  selector: 'app-login',
  standalone: true,
  imports: [MatCardModule, MatFormFieldModule, MatInputModule, MatIconModule, MatButtonModule, CommonModule, FormsModule, ReactiveFormsModule],
  templateUrl: './login.component.html',
  styleUrl: './login.component.css'
})
export class LoginComponent {
  hide = true;
  client = inject(HttpClient);
  constructor(
    public router: Router
  ) { }

  login() {
    this.router.navigate(["/"]);
  }
  
  form = new FormGroup({
    email: new FormControl(
      '',
      [
        Validators.required,
        Validators.email
      ]),
    password: new FormControl(
      '',
      [
        Validators.required,
        Validators.minLength(8),
        Validators.pattern("[0-9]+"),  // la stringa deve contenere almeno un numero 
        Validators.pattern("[a-z]+"),  // la stringa deve contenere almeno una lettera minuscola
        Validators.pattern("[A-Z]+"),  //la stringa deve contenere almeno una lettera maiuscola
        Validators.pattern("[@!$%&*-+]+"),  // la stringa deve contenere almeno un carattere speciale
      ])
  });

  get f() {
    return this.form.controls;
  }

  submit() {
    // console.log(this.form.value);
  }
}
