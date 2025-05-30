# Create a bridge interface named br0
ip link add br0 type bridge
# Bring up the bridge interface
ip link set dev br0 up
# Create a VXLAN interface named vxlan10
ip link add vxlan10 type vxlan id 10 dstport 4789
# Bring up the VXLAN interface
ip link set dev vxlan10 up
# Add the VXLAN interface to the bridge br0
brctl addif br0 vxlan10
# Add the physical interface eth0 to the bridge 
brctl addif br0 eth0

# Enter vtysh command-line interface for router configuration
vtysh
conf t

                          # configuration
interface eth2
    ip address 10.1.1.10/30
    # Enables OSPF on eth2 in Area 0
    ip ospf area 0
# Configure the loopback interface used for BGP and OSPF router ID
interface lo
    # Assigns loopback IP address used in BGP/OSPF
    ip address 1.1.1.4/32
    # Enables OSPF on loopback interface
    ip ospf area 0

# Begin BGP configuration for AS 65002
router bgp 65002
    # This is the Route Reflector's loopback
    neighbor 1.1.1.1 remote-as 65002
    # Use local loopback for session source
    neighbor 1.1.1.1 update-source lo
    # Configure the EVPN address family
    address-family l2vpn evpn
    # Activate EVPN for this neighbor
        neighbor 1.1.1.1 activate
        # Advertise all configured VNIs
        advertise-all-vni
    exit-address-family
# Configure OSPF (Open Shortest Path First) routing protocol 
router ospf

end
exit
