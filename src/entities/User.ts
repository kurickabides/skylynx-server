//User-Entities - Users.ts
export interface User {
  Id: string;
  UserName: string;
  Email: string;
  PasswordHash: string;
}

export interface CreateUserInput {
  username: string;
  email: string;
  passwordHash: string;
}
