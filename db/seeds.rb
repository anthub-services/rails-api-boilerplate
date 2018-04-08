super_admin_user = User.create(
  email: 'superadmin@email.com',
  password: 'password',
  password_confirmation: 'password',
  first_name: 'Super Admin',
  last_name: 'User',
  role: 'Super Admin',
  status: 'active',
  redirect: '',
  created_at: 7.days.ago,
  updated_at: 7.days.ago
)

Path.create(
  user: super_admin_user,
  value: {
    allowedPaths: ['*'],
    excludedPaths: []
  }
)

admin_user = User.create(
  email: 'admin@email.com',
  password: 'password',
  password_confirmation: 'password',
  first_name: 'Admin',
  last_name: 'User',
  role: 'Admin',
  status: 'active',
  redirect: '',
  created_at: 6.days.ago,
  updated_at: 6.days.ago
)

Path.create(
  user: admin_user,
  value: {
    allowedPaths: ['*'],
    excludedPaths: ['/admin/users/delete']
  }
)

user = User.create(
  email: 'user@email.com',
  password: 'password',
  password_confirmation: 'password',
  first_name: 'Default',
  last_name: 'User',
  role: 'User',
  status: 'active',
  redirect: '',
  created_at: 5.days.ago,
  updated_at: 5.days.ago
)

Path.create(
  user: user,
  value: {
    allowedPaths: [
      '/my-profile',
      '/admin',
      '/admin/dashboard',
      '/admin/users',
      '/admin/users/:userId',
      '/admin/settings'
    ],
    exludedPaths: []
  }
)

default_paths = {
  allowedPaths: [
    '/my-profile',
    '/admin',
    '/admin/dashboard'
  ],
  exludedPaths: []
}

referrer_user = User.create(
  email: 'referrer@email.com',
  password: 'password',
  password_confirmation: 'password',
  first_name: 'Referrer',
  last_name: 'User',
  role: 'User',
  status: 'active',
  redirect: '/redux',
  created_at: 4.days.ago,
  updated_at: 4.days.ago
)

Path.create(
  user: referrer_user,
  value: default_paths
)

redirect_user = User.create(
  email: 'redirect@email.com',
  password: 'password',
  password_confirmation: 'password',
  first_name: 'Redirect',
  last_name: 'User',
  role: 'User',
  status: 'active',
  redirect: 'https://github.com/anthub-services/create-react-app-boilerplate',
  created_at: 3.days.ago,
  updated_at: 3.days.ago
)

Path.create(
  user: redirect_user,
  value: default_paths
)

blocked_user = User.create(
  email: 'blocked@email.com',
  password: 'password',
  password_confirmation: 'password',
  first_name: 'Blocked',
  last_name: 'User',
  role: 'User',
  status: 'blocked',
  redirect: '',
  created_at: 2.days.ago,
  updated_at: 2.days.ago
)

Path.create(
  user: blocked_user,
  value: default_paths
)
