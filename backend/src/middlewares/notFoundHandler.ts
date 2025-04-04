import { Request, Response } from 'express';
import { AppError } from './errorHandler';

export const notFoundHandler = (_req: Request, _res: Response): void => {
  throw new AppError(404, 'Route not found');
}; 