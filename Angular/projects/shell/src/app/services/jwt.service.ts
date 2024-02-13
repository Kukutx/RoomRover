import { Injectable } from '@angular/core';
import { jwtDecode } from "jwt-decode";


@Injectable({
  providedIn: 'root'
})
export class JwtService {

  constructor() { }

  DecodeToken(token: string): string {
    return jwtDecode(token);
  }
}
