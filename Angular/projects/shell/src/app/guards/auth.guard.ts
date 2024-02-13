import { HttpClient } from '@angular/common/http';
import { inject } from '@angular/core';
import { CanActivateFn } from '@angular/router';
import { environment } from '../../environments/environment';

export const authGuard: CanActivateFn = (route, state) => {
  if(!sessionStorage.getItem('id_token') || !sessionStorage.getItem('access_token')){
    let client = inject(HttpClient);
    let backUrl: string = environment.backEndUrl + 'api/User';
      client.get('/.auth/me').subscribe((data) => {
      let res = JSON.parse(JSON.stringify(data));
      let token = res[0].id_token;
      let access = res[0].access_token;
      sessionStorage.setItem('id_token', token);
      sessionStorage.setItem('access_token', access);
      client.post(backUrl + "/Create", {}).subscribe();
    });
  }
  return true;
};
