import 'package:flutter/material.dart';

class InputCodeToValidateWidgetOnQrScannerScreen extends StatefulWidget {
  final Function(String) onSearchPressed;
  final Function(String) onChanged;
  final String? initialValue;
  final String? hintText;
  final bool enabled;

  const InputCodeToValidateWidgetOnQrScannerScreen({
    super.key,
    required this.onSearchPressed,
    required this.onChanged,
    this.initialValue,
    this.hintText,
    this.enabled = true,
  });

  @override
  State<InputCodeToValidateWidgetOnQrScannerScreen> createState() =>
      _InputCodeToValidateWidgetOnQrScannerScreenState();
}

class _InputCodeToValidateWidgetOnQrScannerScreenState
    extends State<InputCodeToValidateWidgetOnQrScannerScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _performSearch() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSearching = true;
      });

      // Simular búsqueda con delay
     // Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _isSearching = false;
          });
          widget.onSearchPressed(_controller.text.trim());
          
          // Quitar el foco del campo
          FocusScope.of(context).unfocus();
        }
      //});
    }
  }

  String? _validateInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es requerido';
    }
    
    if (value.trim().length < 3) {
      return 'Debe contener al menos 3 caracteres';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {


    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.blue.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
              
            ),
          ],
          color: Colors.white,
        ),
        child: TextFormField(
          controller: _controller,
          enabled: widget.enabled && !_isSearching,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          validator: _validateInput,
          onChanged: widget.onChanged,
          onFieldSubmitted: (value) {
            _performSearch();
          },
          decoration: InputDecoration(
            hintText: widget.hintText ?? "Ingresa código para validar...",
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            // Borders
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            
            // Error style
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            errorMaxLines: 2,
            
            // Suffix icon (Search button)
            suffixIcon: Container(
              margin: const EdgeInsets.only(right: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: widget.enabled && !_isSearching ? _performSearch : null,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _isSearching 
                        ? Colors.grey[300] 
                        : Colors.blue[600],
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _isSearching
                      ? const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                  ),
                ),
              ),
            ),
            
            // Prefix icon (opcional, para mayor claridad visual)
            prefixIcon: Icon(
              Icons.qr_code_scanner_rounded,
              color: Colors.blue[400],
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
