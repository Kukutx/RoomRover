import { HttpInterceptorFn } from '@angular/common/http';

export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const token = sessionStorage.getItem('id_token');
 
  const access = sessionStorage.getItem('access_token');
 
  var authReq;
 
  if (req.url.includes('.azurewebsites.net/api')) {
    authReq = req.clone({
      headers: req.headers.set('Authorization', 'Bearer ' + token),
    });
  } else if ('graph.microsoft.com') {
    authReq = req.clone({
      headers: req.headers.set('Authorization', 'Bearer ' + access),
    });
  } else {
    authReq = req.clone();
  }
 
  return next(authReq);
};
