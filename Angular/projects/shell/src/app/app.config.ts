import { ApplicationConfig } from '@angular/core';
import { provideRouter } from '@angular/router';

import { routes } from './app.routes';
import { provideAnimations } from '@angular/platform-browser/animations';
import { ToastrModule, provideToastr } from 'ngx-toastr';
import { provideHttpClient, withInterceptors } from '@angular/common/http';
import { authInterceptor } from './interceptors/auth.interceptor';

export const appConfig: ApplicationConfig = {
  providers: [provideRouter(routes), provideHttpClient(withInterceptors([authInterceptor])), provideAnimations(), provideToastr({ positionClass: 'toast-top-center', timeOut: 4500, extendedTimeOut: 4000, preventDuplicates: true, resetTimeoutOnDuplicate: true, countDuplicates: true, closeButton: true, progressBar: true, progressAnimation: "increasing", tapToDismiss: false, })]

};
