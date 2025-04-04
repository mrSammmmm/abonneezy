export interface User {
  id: string;
  email: string;
  password: string;
  name: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface CreateUserDto {
  email: string;
  password: string;
  name: string;
}

export interface LoginUserDto {
  email: string;
  password: string;
}

export interface UpdateUserDto {
  name?: string;
  email?: string;
  password?: string;
} 