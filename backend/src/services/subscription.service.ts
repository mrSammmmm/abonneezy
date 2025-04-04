import { PrismaClient } from '@prisma/client';
import { CreateSubscriptionDto, UpdateSubscriptionDto, Subscription } from '../types/subscription.types';

export class SubscriptionService {
  private prisma: PrismaClient;

  constructor() {
    this.prisma = new PrismaClient();
  }

  async createSubscription(data: CreateSubscriptionDto): Promise<Subscription> {
    return this.prisma.subscription.create({
      data: {
        name: data.name,
        price: data.price,
        billingDate: new Date(data.billingDate),
        description: data.description,
        userId: data.userId!
      }
    });
  }

  async findAllByUserId(userId: string): Promise<Subscription[]> {
    return this.prisma.subscription.findMany({
      where: { userId },
      orderBy: { billingDate: 'asc' }
    });
  }

  async findById(id: string): Promise<Subscription | null> {
    return this.prisma.subscription.findUnique({
      where: { id }
    });
  }

  async updateSubscription(
    id: string,
    data: UpdateSubscriptionDto
  ): Promise<Subscription> {
    return this.prisma.subscription.update({
      where: { id },
      data: {
        ...data,
        billingDate: data.billingDate ? new Date(data.billingDate) : undefined
      }
    });
  }

  async deleteSubscription(id: string): Promise<void> {
    await this.prisma.subscription.delete({
      where: { id }
    });
  }
} 