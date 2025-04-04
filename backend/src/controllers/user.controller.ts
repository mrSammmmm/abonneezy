import { Request, Response, NextFunction } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { UserService } from '../services/user.service';
import { AppError } from '../middlewares/errorHandler';
import { CreateUserDto, LoginUserDto, UpdateUserDto } from '../types/user.types';

export class UserController {
  private userService: UserService;

  constructor() {
    this.userService = new UserService();
  }

  register = async (
    req: Request<{}, {}, CreateUserDto>,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const user = await this.userService.createUser(req.body);
      const token = jwt.sign(
        { id: user.id, email: user.email },
        process.env.JWT_SECRET || 'default_secret',
        { expiresIn: process.env.JWT_EXPIRES_IN || '1d' }
      );

      res.status(201).json({
        status: 'success',
        data: {
          user: {
            id: user.id,
            email: user.email,
            name: user.name
          },
          token
        }
      });
    } catch (error) {
      next(error);
    }
  };

  login = async (
    req: Request<{}, {}, LoginUserDto>,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const { email, password } = req.body;
      const user = await this.userService.findByEmail(email);

      if (!user || !(await bcrypt.compare(password, user.password))) {
        throw new AppError(401, 'Invalid email or password');
      }

      const token = jwt.sign(
        { id: user.id, email: user.email },
        process.env.JWT_SECRET || 'default_secret',
        { expiresIn: process.env.JWT_EXPIRES_IN || '1d' }
      );

      res.json({
        status: 'success',
        data: {
          user: {
            id: user.id,
            email: user.email,
            name: user.name
          },
          token
        }
      });
    } catch (error) {
      next(error);
    }
  };

  getProfile = async (
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const user = await this.userService.findById(req.user!.id);
      if (!user) {
        throw new AppError(404, 'User not found');
      }

      res.json({
        status: 'success',
        data: {
          user: {
            id: user.id,
            email: user.email,
            name: user.name
          }
        }
      });
    } catch (error) {
      next(error);
    }
  };

  updateProfile = async (
    req: Request<{}, {}, UpdateUserDto>,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const user = await this.userService.updateUser(req.user!.id, req.body);
      res.json({
        status: 'success',
        data: {
          user: {
            id: user.id,
            email: user.email,
            name: user.name
          }
        }
      });
    } catch (error) {
      next(error);
    }
  };

  deleteAccount = async (
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      await this.userService.deleteUser(req.user!.id);
      res.status(204).send();
    } catch (error) {
      next(error);
    }
  };
} 