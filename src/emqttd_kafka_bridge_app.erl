-module(emqttd_kafka_bridge_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    gen_conf:init(emqttd_kafka_bridge),
    {ok, Sup} = emqttd_kafka_bridge_sup:start_link(),
    ok = emqttd_access_control:register_mod(auth, emqttd_auth_kafka_bridge, []),
    ok = emqttd_access_control:register_mod(acl, emqttd_acl_kafka_bridge, []),
    emqttd_kafka_bridge:load(application:get_all_env()),
    {ok, Sup}.

stop(_State) ->
    emqttd_kafka_bridge:unload().
