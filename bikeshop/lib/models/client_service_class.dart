class ClientService {
  String serviceId;
  String serviceName;
  String serviceImage;
  String serviceRouter;
  String serviceDescription;
  String buttonText;

  ClientService({
    required this.serviceId,
    required this.serviceName,
    required this.serviceImage,
    required this.serviceRouter,
    required this.serviceDescription,
    required this.buttonText,
  });
}

List<ClientService> listClientServices = [
  ClientService(
    serviceId: '1',
    serviceName: "fixYourBicycle",
    serviceImage: 'assets/images/tools.png',
    serviceRouter: 'FIXBIKE',
    serviceDescription: "repairDesc", buttonText: 'fixNow',
  ),
  ClientService(
    serviceId: '2',
    serviceName: "buyAccessories",
    serviceImage: 'assets/images/accessories.png',
    serviceRouter: 'BUYACCESSORY',
    serviceDescription: "acceDesc",
    buttonText: 'buyNow'
  ),
  ClientService(
    serviceId: '3',
    serviceName: "buySellBicycles",
    serviceImage: 'assets/images/buy-and-sell.png',
    serviceRouter: 'BUYANDSELL',
    serviceDescription: "buySellDesc",
    buttonText: 'discoverNow'
  ),
];
