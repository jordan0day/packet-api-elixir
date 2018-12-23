# PacketApi

An Elixir wrapper library for the [Packet](https://www.packet.com) HTTP API. It uses the [Tesla](https://hex.pm/packages/tesla) library under-the-covers for performing HTTP requests.

*This library is a work in progress!* See the [changelog](CHANGELOG.md) to see the current state of the API.

If you don't have Elixir ~> 1.7 installed, you can use the included `Dockerfile` to spin up a small container with all you need to play around with the library.

## Basic Usage

To access the Packet API, you'll need an [auth token](https://www.packet.com/developers/api/#authentication). With that, you can create a `PacketApi.Request` map, which is then passed into subsequent API calls.

Example:
```elixir
request = PacketApi.request(auth_token: "YOUR AUTH TOKEN HERE")

PacketApi.OperatingSystems.list(request)
```

which returns
```elixir
{:ok, [
   %{
     "distro" => "freebsd",
     "id" => "7014aac5-b97c-4770-8a59-001b5638a4c0",
     "licensed" => false,
     "name" => "FreeBSD 12-testing",
     "preinstallable" => false,
     "pricing" => %{},
     "provisionable_on" => ["c1.large.arm", "baremetal_2a", "c1.small.x86",
      "baremetal_1", "m2.xlarge.x86", "s1.large.x86", "baremetal_s",
      "t1.small.x86", "baremetal_0"],
     "slug" => "freebsd_12_testing",
     "version" => "12-testing"
   },
   %{
     "distro" => "alpine",
     "id" => "06e21644-a769-11e6-80f5-76304dec7eb7",
     "licensed" => false,
     "name" => "Alpine 3",
     "preinstallable" => false,
     "pricing" => %{},
     "provisionable_on" => [],
     "slug" => "alpine_3",
     "version" => "3"
   }
   ...
]}
```

## Device example

To create a new t1.small.x86 device running Ubuntu 16.04 LTS in the Sunnyvale facility, simply create a map with the `facility`, `operating_system`, and `plan` values set, like:

```
device = %{
  # Retrieved via `PacketApi.Facilities.list/1`
  facility: "2b70eb8f-fa18-47c0-aba7-222a842362fd",
  # Retrieved via `PacketApi.OperatingSystems.list/1`
  operating_system: "1b9b78e3-de68-466e-ba00-f2123e89c112",
  # Retrieved via `PacketApi.Plans.list/1`
  plan: "e69c0169-4726-46ea-98f1-939c9e8a3607"
}
```

(Lots of additional options can be set, but `facility`, `operating_system`, and `plan` are required).

Then, using your project_id and your auth token, you can create the new device:

```
[auth_token: "YOUR AUTH TOKEN]
|> PacketApi.request()
|> PacketApi.Devices.create("YOUR PROJECT ID", device)
```

Which, on success, will return a response like:

```
{:ok,
 %{
   "always_pxe" => false,
   "billing_cycle" => "hourly",
   "bonding_mode" => 5,
   "created_at" => "2018-12-23T19:04:46Z",
   "customdata" => %{},
   "description" => nil,
   "facility" => %{
     "address" => %{"href" => "#9dba11a6-0a26-4993-901b-df253713b89e"},
     "code" => "sjc1",
     "features" => ["baremetal", "storage", "layer_2", "global_ipv4",
      "backend_transfer"],
     "id" => "2b70eb8f-fa18-47c0-aba7-222a842362fd",
     "ip_ranges" => ["2604:1380:1000::/36", "147.75.200.0/22",
      "147.75.108.0/22", "147.75.68.0/22", "147.75.88.0/22"],
     "name" => "Sunnyvale, CA"
   },
   "hostname" => "9b8f2f35.packethost.net",
   "href" => "/devices/THE DEVICE ID",
   "id" => "THE DEVICE ID",
   "image_url" => nil,
   "ip_addresses" => [],
   "ipxe_script_url" => nil,
   "iqn" => "iqn.2018-12.net.packet:device.9b8f2f35",
   "locked" => false,
   "network_ports" => [
     %{
       "connected_port" => nil,
       "data" => %{"bonded" => true},
       "hardware" => %{
         "href" => "/hardware/367fa66e-63d6-407b-832f-e4d84a3f76a3"
       },
       "href" => "/ports/6a020275-54f7-451c-bde2-454f01530b58",
       "id" => "6a020275-54f7-451c-bde2-454f01530b58",
       "name" => "bond0",
       "network_type" => "layer3",
       "type" => "NetworkBondPort",
       "virtual_networks" => []
     },
     %{
       "bond" => %{
         "id" => "6a020275-54f7-451c-bde2-454f01530b58",
         "name" => "bond0"
       },
       "connected_port" => %{
         "href" => "/ports/bf925606-2bd5-42a0-ab81-637a07557346"
       },
       "data" => %{"bonded" => true, "mac" => "0c:c4:7a:b5:85:7c"},
       "hardware" => %{
         "href" => "/hardware/367fa66e-63d6-407b-832f-e4d84a3f76a3"
       },
       "href" => "/ports/49217fc6-09d5-46b0-a66c-94d8689d3f05",
       "id" => "49217fc6-09d5-46b0-a66c-94d8689d3f05",
       "name" => "eth0",
       "type" => "NetworkPort",
       "virtual_networks" => []
     },
     %{
       "bond" => %{
         "id" => "6a020275-54f7-451c-bde2-454f01530b58",
         "name" => "bond0"
       },
       "connected_port" => %{
         "href" => "/ports/3acb1ca0-dfe9-42e5-a3bf-1247638c2b92"
       },
       "data" => %{"bonded" => true, "mac" => "0c:c4:7a:b5:85:7d"},
       "hardware" => %{
         "href" => "/hardware/367fa66e-63d6-407b-832f-e4d84a3f76a3"
       },
       "href" => "/ports/dc908985-1f24-4b4a-93e1-21e3fe886d94",
       "id" => "dc908985-1f24-4b4a-93e1-21e3fe886d94",
       "name" => "eth1",
       "type" => "NetworkPort",
       "virtual_networks" => []
     }
   ],
   "operating_system" => %{
     "distro" => "ubuntu",
     "id" => "1b9b78e3-de68-466e-ba00-f2123e89c112",
     "licensed" => false,
     "name" => "Ubuntu 16.04 LTS",
     "preinstallable" => true,
     "pricing" => %{},
     "provisionable_on" => ["baremetal_2a4", "baremetal_2a5", "baremetal_2a6",
      "baremetal_5", "baremetal_hua", "c1.large.arm", "baremetal_2a",
      "c1.large.arm.xda", "baremetal_2a2", "c1.small.x86", "baremetal_1",
      "c1.xlarge.x86", "baremetal_3", "c2.medium.x86", "d1f.optane.x86",
      "d1p.optane.x86", "g2.large.x86", "m1.xlarge.x86", "baremetal_2",
      "m2.xlarge.x86", "s1.large.x86", "baremetal_s", "t1.small.x86",
      "baremetal_0", ...],
     "slug" => "ubuntu_16_04",
     "version" => "16.04"
   },
   "plan" => %{
     "available_in" => [
       %{"href" => "/facilities/2b70eb8f-fa18-47c0-aba7-222a842362fd"},
       %{"href" => "/facilities/e1e9c52e-a0bc-4117-b996-0fc94843ea09"},
       %{"href" => "/facilities/8ea03255-89f9-4e62-9d3f-8817db82ceed"},
       %{"href" => "/facilities/8e6470b3-b75e-47d1-bb93-45b225750975"}
     ],
     "class" => "t1.small.x86",
     "deployment_types" => ["on_demand", "spot_market"],
     "description" => "Our Type 0 configuration is a general use \"cloud killer\" server, with a Intel Atom 2.4Ghz processor and 8GB of RAM.",
     "id" => "e69c0169-4726-46ea-98f1-939c9e8a3607",
     "legacy" => false,
     "line" => "baremetal",
     "name" => "t1.small.x86",
     "pricing" => %{"hour" => 0.07},
     "slug" => "t1.small.x86",
     "specs" => %{
       "cpus" => [%{"count" => 1, "type" => "Intel Atom C2550 @ 2.4Ghz"}],
       "drives" => [%{"count" => 1, "size" => "80GB", "type" => "SSD"}],
       "features" => %{"raid" => false, "txt" => true},
       "memory" => %{"total" => "8GB"},
       "nics" => [%{"count" => 2, "type" => "1Gbps"}]
     }
   },
   "project" => %{"href" => "/projects/YOUR PROJECT ID"},
   "project_lite" => %{
     "href" => "/projects/YOUR PROJECT ID"
   },
   "provisioning_events" => [
     %{
       "body" => "Provisioning started",
       "created_at" => nil,
       "id" => nil,
       "interpolated" => "Provisioning started",
       "ip" => nil,
       "modified_by" => nil,
       "relationships" => [],
       "state" => nil,
       "type" => "provisioning.101"
     },
     %{
       "body" => "Network configured",
       "created_at" => nil,
       "id" => nil,
       "interpolated" => "Network configured",
       "ip" => nil,
       "modified_by" => nil,
       "relationships" => [],
       "state" => nil,
       "type" => "provisioning.102"
     },
     %{
       "body" => "Configuration written, restarting device",
       "created_at" => nil,
       "id" => nil,
       "interpolated" => "Configuration written, restarting device",
       "ip" => nil,
       "modified_by" => nil,
       "relationships" => [],
       "state" => nil,
       "type" => "provisioning.103"
     },
     %{
       "body" => "Connected to magic install system",
       "created_at" => nil,
       "id" => nil,
       "interpolated" => "Connected to magic install system",
       "ip" => nil,
       "modified_by" => nil,
       "relationships" => [],
       "state" => nil,
       "type" => "provisioning.104"
     },
     %{
       "body" => "Server partitions created",
       "created_at" => nil,
       "id" => nil,
       "interpolated" => "Server partitions created",
       "ip" => nil,
       "modified_by" => nil,
       "relationships" => [],
       "state" => nil,
       "type" => "provisioning.105"
     },
     %{
       "body" => "Operating system packages installed",
       "created_at" => nil,
       "id" => nil,
       "interpolated" => "Operating system packages installed",
       "ip" => nil,
       "modified_by" => nil,
       "relationships" => [],
       "state" => nil,
       "type" => "provisioning.106"
     },
     %{
       "body" => "Server networking interfaces configured",
       "created_at" => nil,
       "id" => nil,
       "interpolated" => "Server networking interfaces configured",
       "ip" => nil,
       "modified_by" => nil,
       "relationships" => [],
       "state" => nil,
       "type" => "provisioning.107"
     },
     %{
       "body" => "Cloud-init packages installed and configured",
       "created_at" => nil,
       "id" => nil,
       "interpolated" => "Cloud-init packages installed and configured",
       "ip" => nil,
       "modified_by" => nil,
       "relationships" => [],
       "state" => nil,
       "type" => "provisioning.108"
     },
     %{
       "body" => "Installation finished, rebooting server",
       "created_at" => nil,
       "id" => nil,
       "interpolated" => "Installation finished, rebooting server",
       "ip" => nil,
       "modified_by" => nil,
       "relationships" => [],
       "state" => nil,
       "type" => "provisioning.109"
     },
     %{
       "body" => "Device phoned home and is ready to go",
       "created_at" => nil,
       "id" => nil,
       "interpolated" => "Device phoned home and is ready to go",
       "ip" => nil,
       "modified_by" => nil,
       "relationships" => [],
       "state" => nil,
       "type" => "provisioning.110"
     }
   ],
   "provisioning_percentage" => 0.0,
   "short_id" => "9b8f2f35",
   "ssh_keys" => [%{"href" => "/ssh-keys/YOUR SSH KEY ID"}],
   "state" => "queued",
   "storage" => nil,
   "switch_uuid" => "3bce1f4b",
   "tags" => [],
   "updated_at" => "2018-12-23T19:04:47Z",
   "user" => "root",
   "userdata" => "",
   "volumes" => []
 }}
```

Later, when you're done with the device, you can tear it down with:

```
[auth_token: "YOUR AUTH TOKEN]
|> PacketApi.request()
|> PacketApi.Devices.delete("the device ID")
```

Which will return `:ok` on success.
