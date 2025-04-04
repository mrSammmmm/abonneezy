import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';
import { CreateUserDto, UpdateUserDto, User } from '../types/user.types';
import { AppError } from '../middlewares/errorHandler';

export class UserService {
  private prisma: PrismaClient;

  constructor() {
    this.prisma = new PrismaClient();
  }

  async createUser(data: CreateUserDto): Promise<User> {
    const existingUser = await this.findByEmail(data.email);
    if (existingUser) {
      throw new AppError(400, 'Email already in use');
    }

    const hashedPassword = await bcrypt.hash(data.password, 12);
    return this.prisma.user.create({
      data: {
        ...data,
        password: hashedPassword
      }
    });
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.prisma.user.findUnique({
      where: { email }
    });
  }

  async findById(id: string): Promise<User | null> {
    return this.prisma.user.findUnique({
      where: { id }
    });
  }

  async updateUser(id: string, data: UpdateUserDto): Promise<User> {
    if (data.email) {
      const existingUser = await this.findByEmail(data.email);
      if (existingUser && existingUser.id !== id) {
        throw new AppError(400, 'Email already in use');
      }
    }

    if (data.password) {
      data.password = await bcrypt.hash(data.password, 12);
    }

    return this.prisma.user.update({
      where: { id },
      data
    });
  }

  async deleteUser(id: string): Promise<void> {
    await this.prisma.user.delete({
      where: { id }
    });
  }
} 