initHotel(Hotel) :-
  Hotel = {[clients,C],[bookedrooms,B],[reserved,R]} &
  C = {} &
  B = {} &
  R = {}.

invHotel(Hotel) :-
  Hotel = {[clients,C],[bookedrooms,B],[reserved,R]} &
  dom(R,C) &
  ran(R,B).

bookingRoom(Hotel, Client_i, Room_i, Msg_o, Hotel_) :-
  bookingRoomOk(Hotel, Client_i, Room_i, Msg_o, Hotel_)
  or
  clientAlreadyPresent(Hotel, Client_i, Msg_o, Hotel_)
  or
  roomAlreadyBooked(Hotel, Room_i, Msg_o, Hotel_).

bookingRoomOk(Hotel, Client_i, Room_i, Msg_o, Hotel_) :-
  Hotel = {[clients,C],[bookedrooms,B],[reserved,R]} &
  Client_i nin C &
  Room_i nin B &
  un(C,{Client_i},C_) &
  un(B,{Room_i},B_) &
  un(R,{[Client_i, Room_i]},R_) &
  Msg_o = successfull &
  Hotel_ = {[clients,C_],[bookedrooms,B_],[reserved,R_]}.

clientAlreadyPresent(Hotel, Client_i, Msg_o, Hotel_) :-
  Hotel = {[clients,C] / _} &
  Client_i in C &
  Msg_o = clientPresent &
  Hotel_ = Hotel.

roomAlreadyBooked(Hotel, Room_i, Msg_o, Hotel_) :-
  Hotel = {[bookedrooms,B] / _} &
  Room_i in B &
  Msg_o = roomBooked &
  Hotel_ = Hotel.

bookingCancel(Hotel, Client_i, Room_i, Msg_o, Hotel_) :-
  bookingCancelOk(Hotel, Client_i, Room_i, Msg_o, Hotel_)
  or
  clientNotListed(Hotel, Client_i, Msg_o, Hotel_)
  or
  roomNotListed(Hotel, Room_i, Msg_o, Hotel_).

bookingCancelOk(Hotel, Client_i, Room_i, Msg_o, Hotel_) :-
  Hotel = {[clients,C],[bookedrooms,B],[reserved,R]} &
  Client_i in C &
  Room_i in B &
  diff(C,{Client_i},C_) &
  diff(B,{Room_i},B_) &
  dares({Client_i},R,R_) &
  Msg_o = successfull &
  Hotel_ = {[clients,C_],[bookedrooms,B_],[reserved,R_]}.

clientNotListed(Hotel, Client_i, Msg_o, Hotel_) :-
  Hotel = {[clients,C] / _} &
  set(C) &
  Client_i nin C &
  Msg_o = noClient &
  Hotel_ = Hotel.

roomNotListed(Hotel, Room_i, Msg_o, Hotel_) :-
  Hotel = {[bookedrooms,B] / _} &
  set(B) &
  Room_i nin B &
  Msg_o = noRoom &
  Hotel_ = Hotel.

changeRoom(Hotel, Client_i, Room_i, NewRoom_i, Msg_o, Hotel_) :-
  changeRoomOk(Hotel, Client_i, Room_i, NewRoom_i, Msg_o, Hotel_)
  or
  clientNotListed(Hotel, Client_i, Msg_o, Hotel_)
  or
  roomAlreadyBooked(Hotel, Room_i, Msg_o, Hotel_).

changeRoomOk(Hotel, Client_i, Room_i, NewRoom_i, Msg_o, Hotel_) :-
  Hotel = {[clients,C],[bookedrooms,B],[reserved,R]} &
  Client_i in C &
  Room_i in B &
  NewRoom_i nin B &
  C_ = C &
  diff(B,{Room_i},Y) &
  un(Y,{NewRoom_i},B_) &
  oplus(R,{[Client_i,NewRoom_i]},R_) &
  Msg_o = roomChanged &
  Hotel_ = {[clients,C_],[bookedrooms,B_],[reserved,R_]}.

getClientRoom(Hotel, Client_i, GetRoom_o, Msg_o, Hotel_) :-
  getClientRoomOk(Hotel, Client_i, GetRoom_o, Msg_o, Hotel_)
  or
  wrongClientInserted(Hotel, Client_i, Msg_o, Hotel_).

getClientRoomOk(Hotel, Client_i, GetRoom_o, Msg_o, Hotel_) :-
  Hotel = {[clients,C],[reserved,R] / _} &
  {Client_i} neq {} &
  subset({Client_i}, C) &
  dres({Client_i}, R, GetRoom_o) &
  Msg_o = successfull &
  Hotel_ = Hotel.

wrongClientInserted(Hotel, Client_i, Msg_o, Hotel_) :-
  Hotel = {[clients, C] / _} &
  nsubset({Client_i}, C) &
  Msg_o = wrongClientsIsInserted &
  Hotel_ = Hotel.