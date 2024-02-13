export const environment = {
    production: false,
    backEndUrl: "https://roomroverbedev.azurewebsites.net/",
    graphapis: {
        v1: {
            url: 'https://graph.microsoft.com/v1.0',
            scopes: ['user.read', 'user.readbasic.all', 'user.read.all']
        },
        users: {
            url: 'https://graph.microsoft.com/v1.0/users',
            scopes: ['user.read', 'user.readbasic.all', 'user.read.all']
        },
        profile: {
            url: 'https://graph.microsoft.com/v1.0/me',
            scopes: ['user.read']
        },
        photo: {
            url: 'https://graph.microsoft.com/v1.0/me/photo/$value',
            scopes: ['user.read']
        },
        reports: {
            url: 'https://graph.microsoft.com/v1.0/me/directReports',
            scopes: ['user.read']
        }
    },
};
