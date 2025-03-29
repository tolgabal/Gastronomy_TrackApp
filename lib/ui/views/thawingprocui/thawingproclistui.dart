import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/color.dart';
import 'package:gastrobluecheckapp/data/entity/thawingprocess.dart';
import 'package:gastrobluecheckapp/data/entity/role.dart';
import 'package:gastrobluecheckapp/data/entity/user.dart';
import 'package:gastrobluecheckapp/ui/cubit/thawingproclist_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/thawingprocui/thawingprocinfoui.dart';
import 'package:gastrobluecheckapp/ui/views/thawingprocui/thawingprocsubmitui.dart';
import 'package:gastrobluecheckapp/ui/views/thawingprocui/thawprocassetconInfoui.dart';
import '../../middleware/infobutton.dart';

class ThawingProcListUI extends StatefulWidget {
  final User user;
  final Role userRole;

  const ThawingProcListUI({required this.user, required this.userRole, Key? key}) : super(key: key);

  @override
  _ThawingProcListUIState createState() => _ThawingProcListUIState();
}

class _ThawingProcListUIState extends State<ThawingProcListUI> {
  @override
  void initState() {
    super.initState();
    context.read<ThawingProcListCubit>().thawingLoad(widget.user.hotel, widget.user.section_id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text("Çözülme İşlemleri Listesi"),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Devam Eden'),
              Tab(text: 'Tamamlanan'),
              Tab(text: 'Sevk Edilen'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTab(context, "devam_eden"),
            _buildTab(context, "tamamlanan"),
            _buildTab(context, "sevk_edilen"),
          ],
        ),
        floatingActionButton: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Positioned(
              bottom: 5,
              left: 30,
              child: FloatingActionButton(
                backgroundColor: bigWidgetColor,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Bilgi"),
                        content: Text(InfoMessageProvider.getInfoMessage("thawingprocess") ?? "No information available."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Kapat"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Icon(Icons.info, color: Colors.white),
              ),
            ),
            Positioned(
              bottom: 5,
              right: 0,
              child: FloatingActionButton(
                backgroundColor: bigWidgetColor,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ThawingProcSubmitUI(
                            user: widget.user, userRole: widget.userRole)),
                  );
                },
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, String tabType) {
    return BlocBuilder<ThawingProcListCubit, List<ThawingProcess>>(
      builder: (context, assetList) {
        List<ThawingProcess> filteredAssets = [];

        if (tabType == "devam_eden") {
          filteredAssets = assetList.where((asset) => asset.asset_result.toLowerCase() == "çözündürme" || asset.asset_result.toLowerCase() == "suda çözündürme").toList();
        } else if (tabType == "tamamlanan") {
          filteredAssets = assetList.where((asset) => asset.asset_result.toLowerCase() == "tamamlanan" && asset.kalan > 0).toList();
        } else if (tabType == "sevk_edilen") {
          filteredAssets = assetList.where((asset) => asset.asset_quantity == 0).toList();
        }

        if (filteredAssets.isEmpty) {
          return const Center(child: Text("Ürün bulunmamakta."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: filteredAssets.length,
          itemBuilder: (context, index) {
            return _buildListItem(filteredAssets[index], tabType);
          },
        );
      },
    );
  }

  Widget _buildListItem(ThawingProcess asset, String tabType) {
    return GestureDetector(
      onTap: () {
        if (tabType == "devam_eden") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ThawProcAssetConInfoUI(asset: asset, user: widget.user, userRole: widget.userRole), // Gidilecek sayfa
            ),
          );
        } else if (tabType == "tamamlanan") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ThawingProcInfoUI(asset: asset, user: widget.user, userRole: widget.userRole), // Gidilecek sayfa
            ),
          );
        }
      },
      child: Dismissible(
        key: Key(asset.id.toString()),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerRight,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("${asset.asset_name} ürününü silmek istediğinizden emin misiniz?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Hayır"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Evet"),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (direction) {
          context.read<ThawingProcListCubit>().thawingProcDelete(asset.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${asset.asset_name} silindi",
                style: const TextStyle(color: Colors.black),
              ),
              backgroundColor: smallWidgetColor,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: smallWidgetColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: tabType == "sevk_edilen" // Burada if kontrolü
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Merkeze yerleştirme
                children: [
                  Text(asset.asset_name, style: const TextStyle(fontSize: 15)),
                  Text("${asset.asset_process_time}", style: const TextStyle(fontSize: 10)),
                  Text("${asset.asset_sending_quantity} kg", style: const TextStyle(fontSize: 10)),
                  Text("${asset.asset_sending_place}", style: const TextStyle(fontSize: 10)),

                ],
              )
                  : Text(asset.asset_name, style: const TextStyle(fontSize: 18)),
            ),
          ),
        ),
      ),
    );
  }
}
