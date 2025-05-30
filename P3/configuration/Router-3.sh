# Create a bridge named "br0"
ip link add br0 type bridge
# activate the bridge interface
ip link set dev br0 up
# Create a VXLAN tunnel interface "vxlan10" with VXLAN ID 10 and destination port 4789
ip link add vxlan10 type vxlan id 10 dstport 4789
# Bring the VXLAN interface "vxlan10" up
ip link set dev vxlan10 up
# Add the VXLAN interface to the bridge "br0" (this connects the VXLAN to the bridge)
brctl addif br0 vxlan10
# Add the physical interface "eth0" to the bridge "br0" (connects eth0 to the bridge)
brctl addif br0 eth0

# Enter vtysh command-line interface for router configuration
vtysh
conf t
                                # configuration
interface eth1
    ip address 10.1.1.6/30
    # Enable OSPF on the loopback interface and assign it to OSPF Area 0
    ip ospf area 0
# Configure loopback interface with IP address 1.1.1.3/32
interface lo
    ip address 1.1.1.3/32
    ip ospf area 0

# Begin BGP configuration for AS 65002
router bgp 65002
    # Specify the remote AS
    neighbor 1.1.1.1 remote-as 65002
    # Use the loopback interface as the source IP for BGP updates
    neighbor 1.1.1.1 update-source lo
    # Enter the EVPN address family
    address-family l2vpn evpn
        # Activate EVPN for the BGP neighbor 1.1.1.1
        neighbor 1.1.1.1 activate
        # Advertise all VNI (Virtual Network Identifier) in the EVPN
        advertise-all-vni
    exit-address-family
# Configure OSPF (Open Shortest Path First) routing protocol
router ospf

end
exit
