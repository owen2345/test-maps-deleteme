export type Nullable<T> = T | null;

export interface DealerType {
  id: number
  name: string
  phone: string
  street: string
  city: string
  zipcode: string
  country: string
  latitude: number
  longitude: number
}