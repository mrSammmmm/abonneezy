export interface Subscription {
  id: string;
  name: string;
  price: number;
  billingDate: Date;
  description?: string;
  userId: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface CreateSubscriptionDto {
  name: string;
  price: number;
  billingDate: Date;
  description?: string;
  userId?: string; // Optional because it will be set from the authenticated user
}

export interface UpdateSubscriptionDto {
  name?: string;
  price?: number;
  billingDate?: Date;
  description?: string;
} 