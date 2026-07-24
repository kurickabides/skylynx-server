// ================================================
// ✅ Interface: User
// Description: User entity and create-user input contracts
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: entities/User.ts
// ================================================
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
