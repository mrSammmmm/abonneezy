import { Request, Response, NextFunction } from 'express';
import { SubscriptionService } from '../services/subscription.service';
import { AppError } from '../middlewares/errorHandler';
import { CreateSubscriptionDto, UpdateSubscriptionDto } from '../types/subscription.types';

export class SubscriptionController {
  private subscriptionService: SubscriptionService;

  constructor() {
    this.subscriptionService = new SubscriptionService();
  }

  create = async (
    req: Request<{}, {}, CreateSubscriptionDto>,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const subscription = await this.subscriptionService.createSubscription({
        ...req.body,
        userId: req.user!.id
      });

      res.status(201).json({
        status: 'success',
        data: { subscription }
      });
    } catch (error) {
      next(error);
    }
  };

  getAll = async (
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const subscriptions = await this.subscriptionService.findAllByUserId(
        req.user!.id
      );

      res.json({
        status: 'success',
        data: { subscriptions }
      });
    } catch (error) {
      next(error);
    }
  };

  getOne = async (
    req: Request<{ id: string }>,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const subscription = await this.subscriptionService.findById(req.params.id);
      
      if (!subscription) {
        throw new AppError(404, 'Subscription not found');
      }

      if (subscription.userId !== req.user!.id) {
        throw new AppError(403, 'Not authorized to access this subscription');
      }

      res.json({
        status: 'success',
        data: { subscription }
      });
    } catch (error) {
      next(error);
    }
  };

  update = async (
    req: Request<{ id: string }, {}, UpdateSubscriptionDto>,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const subscription = await this.subscriptionService.findById(req.params.id);
      
      if (!subscription) {
        throw new AppError(404, 'Subscription not found');
      }

      if (subscription.userId !== req.user!.id) {
        throw new AppError(403, 'Not authorized to update this subscription');
      }

      const updatedSubscription = await this.subscriptionService.updateSubscription(
        req.params.id,
        req.body
      );

      res.json({
        status: 'success',
        data: { subscription: updatedSubscription }
      });
    } catch (error) {
      next(error);
    }
  };

  delete = async (
    req: Request<{ id: string }>,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const subscription = await this.subscriptionService.findById(req.params.id);
      
      if (!subscription) {
        throw new AppError(404, 'Subscription not found');
      }

      if (subscription.userId !== req.user!.id) {
        throw new AppError(403, 'Not authorized to delete this subscription');
      }

      await this.subscriptionService.deleteSubscription(req.params.id);
      res.status(204).send();
    } catch (error) {
      next(error);
    }
  };
} 