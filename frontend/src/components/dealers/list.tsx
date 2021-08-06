import React, {useContext} from 'react';
import DealersContext from "./context";
import {TDealerType} from "pages/dealers";

export default function List({ dealers }: { dealers: TDealerType[] }) {
  const dealerContext = useContext(DealersContext);

  return (
    <ul>
      {dealers.map(dealer =>
        <li
          onClick={ () => dealerContext.changeData({ selectedDealer: dealer.id }) }
          className={dealerContext.selectedDealer === dealer.id ? "selected" : ""}
        >
          {dealer.name}
        </li>
      )}
    </ul>
  );
}
