import React from 'react';
import './dealers.scss';
import Map from 'components/dealers/map';
import List from 'components/dealers/list';
import DealersContext, { TDealersContext, defaultContextValue } from 'components/dealers/context';
import {DealerType, Nullable} from "interfaces";

export type TDealerType = Pick<DealerType, 'id'|'name'|'latitude'|'longitude'>;
type TApiState = {
  error?: Nullable<string>,
  loading?: boolean
}

function Dealers() {
  const [dealerContextData, setDealerContextData] =
    React.useState<TDealersContext>(defaultContextValue);
  const changeDealerData = (data: Partial<TDealersContext>) =>
    setDealerContextData({ ...dealerContextData, ...data });
  const [dealers, setDealers] = React.useState<TDealerType[]>([]);
  const [apiState, setApiState] = React.useState<TApiState>({});

  React.useEffect(() => {
    fetch("http://localhost:3001/api/dealers")
      .then(res => res.json())
      .then(
        (result) => {
          setDealers(result as TDealerType[]);
          setApiState({ loading: true });
        },
        (error) => {
          setApiState({ error, loading: true });
        }
      )
  }, []);


  return (
    <DealersContext.Provider value={{ ...dealerContextData, ...{ changeData: changeDealerData } } }>
      {apiState.error && <div className="flash error">{apiState.error}</div>}
      {!apiState.loading && <div className="flash notice">Loading....</div>}
      {apiState.loading && !apiState.error &&
      <div id="dealers_page">
        <div className="list_panel">
          <List dealers={dealers} />
        </div>

        <div className="map_panel">
          <Map dealers={dealers} />
        </div>
      </div>
      }
    </DealersContext.Provider>
  );
}

export default Dealers;
