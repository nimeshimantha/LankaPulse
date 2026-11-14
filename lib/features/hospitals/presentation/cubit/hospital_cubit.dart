import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/hospital_model.dart';

abstract class HospitalState extends Equatable {
  const HospitalState();
  @override
  List<Object?> get props => [];
}

class HospitalInitial extends HospitalState {}
class HospitalLoading extends HospitalState {}
class HospitalLoaded extends HospitalState {
  final List<Hospital> hospitals;
  final String activeFilter; // 'All', 'Government', 'Private'
  final String searchQuery;

  const HospitalLoaded({
    required this.hospitals,
    this.activeFilter = 'All',
    this.searchQuery = '',
  });

  List<Hospital> get filteredHospitals {
    return hospitals.where((h) {
      final matchesType = activeFilter == 'All' ||
          h.type.toLowerCase() == activeFilter.toLowerCase();
      final matchesSearch = searchQuery.isEmpty ||
          h.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          h.address.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesType && matchesSearch;
    }).toList();
  }

  @override
  List<Object?> get props => [hospitals, activeFilter, searchQuery];
}

class HospitalCubit extends Cubit<HospitalState> {
  HospitalCubit() : super(HospitalInitial()) {
    loadHospitals();
  }

  void loadHospitals() {
    emit(HospitalLoading());
    final mockHospitals = [
      const Hospital(
        id: '1',
        name: 'National Hospital of Sri Lanka (NHSL)',
        type: 'Government',
        address: 'E W Perera Mawatha, Colombo 01000',
        phone: '0112 691 111',
        emergencyPhone: '0112 693 711',
        distance: '1.2 km',
        operatingHours: '24 Hours Emergency Response',
        hasIcu: true,
        hasAmbulance: true,
        latitude: 6.9186,
        longitude: 79.8687,
      ),
      const Hospital(
        id: '2',
        name: 'Lanka Hospitals PLC',
        type: 'Private',
        address: '578 Elvitigala Mawatha, Colombo 00500',
        phone: '0115 530 000',
        emergencyPhone: '0115 430 000',
        distance: '3.4 km',
        operatingHours: '24 Hours Open',
        hasIcu: true,
        hasAmbulance: true,
        latitude: 6.8925,
        longitude: 79.8778,
      ),
      const Hospital(
        id: '3',
        name: 'Asiri Central Hospital',
        type: 'Private',
        address: '114 Norris Canal Rd, Colombo 01000',
        phone: '0114 665 500',
        emergencyPhone: '0114 665 555',
        distance: '2.1 km',
        operatingHours: '24 Hours Open',
        hasIcu: true,
        hasAmbulance: true,
        latitude: 6.9171,
        longitude: 79.8665,
      ),
      const Hospital(
        id: '4',
        name: 'Colombo South Teaching Hospital (Kalubowila)',
        type: 'Government',
        address: 'Hospital Rd, Dehiwala-Mount Lavinia',
        phone: '0112 763 038',
        emergencyPhone: '0112 763 261',
        distance: '6.8 km',
        operatingHours: '24 Hours Open',
        hasIcu: true,
        hasAmbulance: true,
        latitude: 6.8711,
        longitude: 79.8821,
      ),
      const Hospital(
        id: '5',
        name: 'Nawaloka Hospitals PLC',
        type: 'Private',
        address: '23 Deshamanya H K Dharmadasa Mawatha, Colombo 00200',
        phone: '0115 577 111',
        emergencyPhone: '0115 577 119',
        distance: '2.8 km',
        operatingHours: '24 Hours Open',
        hasIcu: true,
        hasAmbulance: true,
        latitude: 6.9248,
        longitude: 79.8542,
      ),
    ];

    emit(HospitalLoaded(hospitals: mockHospitals));
  }

  void setFilter(String filter) {
    if (state is HospitalLoaded) {
      final current = state as HospitalLoaded;
      emit(HospitalLoaded(
        hospitals: current.hospitals,
        activeFilter: filter,
        searchQuery: current.searchQuery,
      ));
    }
  }

  void setSearchQuery(String query) {
    if (state is HospitalLoaded) {
      final current = state as HospitalLoaded;
      emit(HospitalLoaded(
        hospitals: current.hospitals,
        activeFilter: current.activeFilter,
        searchQuery: query,
      ));
    }
  }
}
