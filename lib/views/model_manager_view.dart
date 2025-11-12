import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../services/model_service.dart';
import '../constants/app_constants.dart';
import '../widgets/model_item.dart';
import '../widgets/download_progress_bar.dart';

class ModelManagerView extends StatefulWidget {
  const ModelManagerView({super.key});

  @override
  State<ModelManagerView> createState() => _ModelManagerViewState();
}

class _ModelManagerViewState extends State<ModelManagerView> {
  final ModelService _modelService = ModelService();
  List<String> _downloadedModels = [];
  bool _isLoading = false;
  double _downloadProgress = 0.0;
  String _downloadingModel = '';

  @override
  void initState() {
    super.initState();
    _loadDownloadedModels();
  }

  Future<void> _loadDownloadedModels() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final models = await _modelService.getDownloadedModels();
      setState(() {
        _downloadedModels = models;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('加载模型列表失败: $e')));
      }
    }
  }

  Future<void> _downloadModel(String modelName) async {
    setState(() {
      _isLoading = true;
      _downloadProgress = 0.0;
      _downloadingModel = modelName;
    });

    try {
      await _modelService.downloadModel(modelName, (progress) {
        setState(() {
          _downloadProgress = progress;
        });
      });

      // 下载完成后刷新模型列表
      await _loadDownloadedModels();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$modelName 模型下载完成')));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _downloadProgress = 0.0;
        _downloadingModel = '';
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('下载失败: $e')));
      }
    }
  }

  Future<void> _deleteModel(String modelName) async {
    try {
      await _modelService.deleteModel(modelName);
      await _loadDownloadedModels();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$modelName 模型已删除')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('删除失败: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('${localizations.model}管理')),
      body: _isLoading && _downloadProgress > 0
          ? _buildDownloadProgressView(localizations)
          : _buildModelListView(localizations),
    );
  }

  Widget _buildDownloadProgressView(AppLocalizations localizations) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DownloadProgressBar(
          progress: _downloadProgress,
          title: '正在下载 $_downloadingModel 模型',
          subtitle: '${(_downloadProgress * 100).round()}%',
        ),
      ),
    );
  }

  Widget _buildModelListView(AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('选择默认模型', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),

          // 默认模型选择
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: AppConstants.whisperModels.map((model) {
                  return RadioListTile<String>(
                    title: Text(model['displayName']),
                    subtitle: Text('${model['size']}MB'),
                    value: model['name'],
                    groupValue: 'medium', // 默认选择medium模型
                    onChanged: (value) {
                      // 保存设置
                    },
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text('已下载模型', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),

          // 已下载模型列表
          Expanded(
            child: _downloadedModels.isEmpty
                ? Center(child: Text('暂无已下载模型'))
                : ListView.builder(
                    itemCount: _downloadedModels.length,
                    itemBuilder: (context, index) {
                      final modelName = _downloadedModels[index];
                      return ModelItem(
                        name: modelName,
                        displayName: modelName,
                        size: 0, // 实际大小需要从文件系统获取
                        isDownloaded: true,
                        onDelete: () => _deleteModel(modelName),
                      );
                    },
                  ),
          ),

          const SizedBox(height: 16),

          // 可下载模型列表
          Text('可下载模型', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              itemCount: AppConstants.whisperModels.length,
              itemBuilder: (context, index) {
                final model = AppConstants.whisperModels[index];
                final isDownloaded = _downloadedModels.contains(model['name']);

                return ModelItem(
                  name: model['name'],
                  displayName: model['displayName'],
                  size: model['size'],
                  isDownloaded: isDownloaded,
                  onDownload: isDownloaded
                      ? null
                      : () => _downloadModel(model['name']),
                  onDelete: isDownloaded
                      ? () => _deleteModel(model['name'])
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
