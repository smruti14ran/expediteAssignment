import { HttpClient } from '@angular/common/http';
import { Product } from './products';
import { EventEmitter, Injectable } from '@angular/core';


@Injectable({
  providedIn: 'root'
})
export class CartService {
  items: Product[] = [];
  messageEvent = new EventEmitter<any>();

  constructor(
    private http: HttpClient
  ) {}

  addToCart(product: Product) {
    this.items.push(product);
  }

  getItems() {
    return this.items;
  }

  clearCart() {
    this.items = [];
    return this.items;
  }

  getShippingPrices() {
    return this.http.get<{type: string, price: number}[]>('/assets/shipping.json');

  }
}
