import React, { useContext } from 'react';
import { withScriptjs, withGoogleMap, GoogleMap, Marker, InfoWindow } from "react-google-maps";
import DealersContext from "./context";
import { TDealerType } from 'pages/dealers';

const Map = withScriptjs(withGoogleMap((props: any) => {
  const dealers: TDealerType[] = props.dealers;
  const firstDealer = dealers[0];
  const dealerContext = useContext(DealersContext);

  return (
    <GoogleMap
      defaultZoom={2}
      defaultCenter={{ lat: firstDealer?.latitude || -34.397, lng: firstDealer?.longitude || 150.644 }}
    >
      { dealers.map(dealer =>
        <Marker
          title={dealer.name}
          position={{ lat: dealer.latitude, lng: dealer.longitude }}
          onClick={() => dealerContext.changeData({ selectedDealer: dealer.id })}
        >
          {(dealerContext.selectedDealer === dealer.id) &&
            <InfoWindow onCloseClick={() => dealerContext.changeData({ selectedDealer: null })}>
              <div>{dealer.name}</div>
            </InfoWindow>
          }
        </Marker>
      )}
    </GoogleMap>
  );
}));


export default function MapWrapper({ dealers }: { dealers: TDealerType[] }) {
  return(
    <Map
      dealers={dealers}
      isMarkerShown
      googleMapURL="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=geometry,drawing,places&key=AIzaSyBPivMXXpdPFpyCvcd9aqgZ7tiCwzTnB-k"
      loadingElement={<div style={{ height: `100%` }} />}
      containerElement={<div style={{ height: `400px` }} />}
      mapElement={<div style={{ height: `100%` }} />}
    />
  );
}