import React from 'react';
import {Nullable} from 'interfaces';

export type TDealersContext = {
  selectedDealer: Nullable<number>,
  changeData: (data: Partial<TDealersContext>) => void,
}

export const defaultContextValue = { selectedDealer: null, changeData: () => {} };
const DealersContext = React.createContext<TDealersContext>(defaultContextValue);

export default DealersContext;