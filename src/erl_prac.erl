-module(erl_prac).
-export([mqtt_handle_publish/1, mqtt_publish/2, ip_in_subnet/2, ip_in_subnet/3, ip_in_subnet_testing/0, trevor/0, ryan/0]). 

-include_lib("emqttc/include/emqttc.hrl").

mqtt_handle_publish({publish,Topic,Payload}) ->
   
    ok. 
   % lager:info("AWS-LOG|TOPIC|~p|PAYLOAD|~p", [Topic, Payload]).
    
    %lager:info("payload matches >123<: ~p", [string:equal(Payload, "123")]).

    %mqtt_publish(erlang:list_to_binary(string:replace(Topic,<<"send">>,<<"receive">>)), <<"returned: ", Payload/binary>>).


mqtt_publish(Topic, Payload) ->
    ecpool:with_client(?EMQTTC_POOL, fun(C) -> emqttc:publish(C, Topic, Payload) end). 


ip_in_subnet(IP, Subnet) when is_list(IP), is_list(Subnet) ->
    
    IP1 = element(2, inet:parse_ipv4strict_address(IP)),
    IP2 = element(2, inet:parse_ipv4strict_address(hd(string:lexemes(Subnet, "/")))),
    Netmask = list_to_integer(lists:last(string:lexemes(Subnet, "/"))),
    ip_in_subnet(IP1, IP2, Netmask); 
    
ip_in_subnet(IP, Subnet) ->
    lager:info("error, IP: ~p, Subnet: ~p", [IP, Subnet]),
    lager:info("IP expected as \"192.168.0.1\""),
    lager:info("Subnet expected as \"192.168.0.1/24\"").

ip_in_subnet({IP1_1, IP1_2, IP1_3, IP1_4} = IP1, {IP2_1, IP2_2, IP2_3, IP2_4} = IP2, Netmask) when is_tuple(IP1), is_tuple(IP2), is_integer(Netmask) ->

     Net = trunc(math:pow(2, Netmask) - 1) bsl (32 - Netmask),
     {N1, N2, N3, N4} = {Net bsr 24, Net bsr 16, Net bsr 8, Net},
     {IP1_1 band N1, IP1_2 band N2, IP1_3 band N3, IP1_4 band N4} =:=
            {IP2_1 band N1, IP2_2 band N2, IP2_3 band N3, IP2_4 band N4};

ip_in_subnet(IP1, IP2, Netmask) ->
    
    lager:info("error, IP1: ~p, IP2: ~p, Netmask: ~p", [IP1, IP2, Netmask]),
    lager:info("IP expected as \"192.168.0.1\""),
    lager:info("Subnet expected as \"192.168.0.1/24\"").

is_on_subnet({Ip1, Ip2, Ip3, Ip4}, {Sub1, Sub2, Sub3, Sub4}, MaskNum) ->
     <<Ip:MaskNum, _/bits>> = <<Ip1, Ip2, Ip3, Ip4>>,
     <<Subnet:MaskNum, _/bits>> = <<Sub1, Sub2, Sub3, Sub4>>,
     <<Mask:MaskNum, _/bits>> = <<16#FFFFFFFF:MaskNum>>,
     (Ip band Mask) == (Subnet band Mask).

f1(0,_) -> 
   []; 
   
f1(N,Term) when N > 0 -> 
   ip_in_subnet({13, 29, 160, 7}, {13, 16, 0, 0}, 26), 
   [Term|f1(N-1,Term)]. 

f2(0,_) -> 
   []; 
   
f2(N,Term) when N > 0 -> 
   is_on_subnet({13, 29, 160, 7}, {13, 16, 0, 0}, 26), 
   [Term|f2(N-1,Term)]. 

ip_in_subnet_testing() -> 

    IP1 = "throwerror",
    SN1 = "192.168.7.244/24",
    
    IP2 = "10.0.0.1",
    SN2 = "10.0.0.0/24",
    
    IP3 = "13.29.160.7",
    SN3 = "13.16.0.0/16",
    
    IP4 = "192.168.7.173",
    SN4 = "192.168.7.244/31",
    
    IP5 = "192.168.0.232",
    SN5 = "192.168.0.233/32",
    
    lager:info("IP: ~p, Subnet: ~p, IP on Subnet: ~p", [IP1, SN1, ip_in_subnet(IP1, SN1)]),
    lager:info("IP: ~p, Subnet: ~p, IP on Subnet: ~p", [IP2, SN2, ip_in_subnet(IP2, SN2)]),
    lager:info("IP: ~p, Subnet: ~p, IP on Subnet: ~p", [IP3, SN3, ip_in_subnet(IP3, SN3)]),
    lager:info("IP: ~p, Subnet: ~p, IP on Subnet: ~p", [IP4, SN4, ip_in_subnet(IP4, SN4)]),
    lager:info("IP: ~p, Subnet: ~p, IP on Subnet: ~p", [IP5, SN5, ip_in_subnet(IP5, SN5)]).

trevor() ->
    T1_start = os:timestamp(),
    f1(1000000, 1),
    T1_stop  = os:timestamp(),
    lager:info("  elapsed time: ~p", [timer:now_diff(T1_stop, T1_start)/1000000]).    

ryan() ->
    T1_start = os:timestamp(),
    f2(1000000, 1),
    T1_stop  = os:timestamp(),
    lager:info("  elapsed time: ~p", [timer:now_diff(T1_stop, T1_start)/1000000]).    


   
