%NO_PFILE
function [funs, student_id] = student_sols()
%STUDENT_SOLS Contains all student solutions to problems.

% ----------------------------------------
%               STEP 1
% ----------------------------------------
% Set to your birthdate / the birthdate of one member in the group.
% Should a numeric value of format YYYYMMDD, e.g.
% student_id = 19900101;
% This value must be correct in order to generate a valid secret key.
student_id = 19990919;


% ----------------------------------------
%               STEP 2
% ----------------------------------------
% Your task is to implement the following skeleton functions.
% You are free to use any of the utility functions located in the same
% directory as this file as well as any of the standard matlab functions.


	function z = add_cyclic_prefix(x,Ncp)  %#ok<*INUSD>
		% Adds (prepends) a Ncp long cyclic prefix to the ofdm block x.
		x = x(:);   %#ok<*NASGU> % Ensure x is a column vector
		z = [x(end-Ncp+1:1:end).', x.'].';
    end

    function x = remove_cyclic_prefix(z,Ncp)
        % Removes a Ncp long cyclic prefix from the ofdm package z
        z = z(:);   % Ensure z is a column vector
        x = z(Ncp+1:1:end);
    end

    function symb = bits2qpsk(bits)
        % Encode bits as qpsk symbols 
        % ARGUMENTS:
        % bits = array of bits. Numerical values converted as:
        %   zero -> zero
        %   nonzero -> one
        % Must be of even length!
        % OUTPUT:
        % x = complex array of qpsk symbols encoding the bits. Will contain
        % length(bits)/2 elements. Valid output symbols are
        % 1/sqrt(2)*(+/-1 +/- i). Symbols grouped by pairs of bits, where
        % the first corresponds the real part of the symbol while the
        % second corresponds to the imaginary part of the symbol. A zero
        % bit should be converted to a negative symbol component, while a
        % nonzero bit should be converted to a positive symbol component.
        
        % Convert bits vector of +/- 1
        bits = double(bits);
        bits = bits(:);

        for i = 1:1:length(bits)
            if bits(i) == 0
                bits(i) = -1;
            else
                bits(i) = 1;
            end
        end

        if rem(length(bits),2) == 1
            error('bits must be of even length');
        end

        for k = 1:1:length(bits)/2
            symb(k) = sqrt(1/2)*(bits(2*k-1)+1i*bits(2*k));
        end

        symb = symb.';
    end

    function bits = qpsk2bits(x)
        % Convert qpsk symbols to bits.
        % Output will be a vector twice as long as the input x, with values
        % 0 or 1.
        x = x(:);
        bits = false(2*length(x),1);
        % Note: you only need to check which quadrant of the complex plane
        % the symbol lies in in order to map it to a pair of bits. The
        % first bit corresponds to the real part of the symbol while the
        % second bit corresponds to the imaginary part of the symbol.

        bits_double = zeros(length(x),2);

        for k = 1:1:length(x)
            if real(x(k)) > 0 && imag(x(k)) > 0
                bits_double(k,:) = [1, 1];
            elseif real(x(k)) < 0 && imag(x(k)) > 0
                bits_double(k,:) = [-1, 1];
            elseif real(x(k)) > 0 && imag(x(k)) < 0
                bits_double(k,:) = [1, -1];
            elseif real(x(k)) < 0 && imag(x(k)) < 0
                bits_double(k,:) = [-1, -1];
            end
        end

        for l = 1:1:length(bits_double)
            if l == 1
                bits_org = [bits_double(l,:)];
            else
                bits_org = [bits_org, bits_double(l,:)];
            end
        end

        bits = bits_org.';

        bits(bits ~= -1) = 1;
        bits(bits == -1) = 0;

        % Ensure output is of correct type
        % zero value -> logical zero
        % nonzero value -> logical one
        bits = logical(bits);
    end

    function [rx, evm, ber, symbs] = sim_ofdm_known_channel(tx, h, N_cp, snr, sync_err)
        % Simulate OFDM signal transmission/reception over a known channel.
        %
        % -----------------------------------------------------------------
        % NOTE: THIS FUNCTION WILL NOT BE SELF-TESTED!
        % It will be up to you to study the output from this function and
        % determine if the results are correct or not.
        % -----------------------------------------------------------------
        %
        % Arguments:
        %   tx          Bits to transmit [-]
        %   h           Channel impulse response [-]
        %   N_cp        Cyclic prefix length [samples]
        %   snr         Channel signal/noise ration to apply [dB]
        %   sync_err    Reciever synchronization error [samples]
        % Outputs:
        %   rx          Recieved bits [-]
        %   evm         Error vector magnitude (see below) [-]
        %   ber         Bit error rate (see below) [-]
        %   symbs       Structure containing fields:
        %       .tx         Transmitted symbols
        %       .rx_pe      Recieved symbols, pre-equalization
        %       .rx_e       Recieved symbols, post-equalization
        %
        % In this function, you will now fully implement a simulated
        % base-band OFDM communication scheme. The relevant steps in this
        % are:
        %   - Get a sequence of bits to transmit
        %   - Convert the bits to OFDM symbols
        %   - Create an OFDM block from the OFDM symbols
        %   - Add a cyclic prefix
        %   - Simulate the transmission and reception over the channel using the
        %   simulate_baseband_channe function.
        %   - Remove the cyclic prefix from the recieved message.
        %   - Equalize the recieved symbols by the channel gain
        %   - Convert the equalized symbols back to bits
        %   - Compare the recieved bits/symbols to the transmitted bits/symbols.
        %
        % If you have implemented the skeleton functions earlier in this
        % file then this function will be very simple as you can call your
        % functions to perform the needed tasks.
		
		warning('Note that this function is _not_ self-tested. It is up to you to study the output any verify that it is correct! You can remove this warning if you wish.');
        
        % Ensure inputs are column vectors
        tx = tx(:);
        h = h(:);

        tx_alt = double(tx);

        for i = 1:1:length(tx_alt)
            if tx_alt(i) == 0
                tx_alt(i) = -1;
            else
                tx_alt(i) = 1;
            end
        end

        if rem(length(tx_alt),2) == 1
            error('bits must be of even length');
        end
        
        % Convert bits to QPSK symbols
        for k = 1:1:length(tx_alt)/2
            x(k) = sqrt(1/2)*(tx_alt(2*k-1)+1i*tx_alt(2*k));
        end

        x = x.';
        
        symbs.tx = x;   % Store transmitted symbols for later
        
        % Number of symbols in message
        N = length(x);

        % Create OFDM time-domain block using IDFT
        for n = 1:1:N
            for k = 1:1:N
                if k == 1
                    z(n) = (1/N).*x(k).*exp(1i*2*pi*(k-1)*(n-1)/N);
                else
                    z(n) = z(n) + (1/N).*x(k).*exp(1i*2*pi*(k-1)*(n-1)/N);
                end
            end
        end

        z = z.';

        % Add cyclic prefix to create OFDM package
        zcp = [z(end-N_cp+1:1:end).', z.'].';

        % Send package over channel
        ycp = simulate_baseband_channel(zcp, h, snr, sync_err);
        % Only keep the first N+Ncp recieved samples. Consider why ycp is longer
        % than zcp, and why we only need to save the first N+Ncp samples. This is
        % important to understand.
        ycp = ycp(1:N+N_cp); 

        % Remove cyclic prefix
        y = ycp(N_cp+1:1:end);

        % Convert to frequency domain using DFT
        for k = 1:1:N
            for n = 1:1:N
                if n == 1
                    r(k) = y(n).*exp(-1i*2*pi*(k-1)*(n-1)/N);
                else
                    r(k) = r(k) + y(n).*exp(-1i*2*pi*(k-1)*(n-1)/N);
                end
            end
        end

        r = r.';
        
        symbs.rx_pe = r; % Store symbols for later

        % Remove effect of channel by equalization. Here, we can do this by
        % dividing r (which is in the frequency domain) by the channel gain (also
        % in the frequency domain).
        Nh = length(h);

        for k = 1:1:N
            for n = 1:1:Nh
                if n == 1
                    H(k) = h(n).*exp(-1i*2*pi*(k-1)*(n-1)/N);
                else
                    H(k) = H(k) + h(n).*exp(-1i*2*pi*(k-1)*(n-1)/N);
                end
            end
        end

        H = H.';

        r_eq = r./H;
        
        symbs.rx_e = r_eq; %Store symbols for later

        % Calculate the quality of the received symbols.
        % The error vector magnitude (EVM) is one useful metric.
        evm = norm(x - r_eq)/sqrt(N);

        % Convert the recieved symsbols to bits
        rx = false(2*length(r_eq),1);

        bits_double = zeros(length(r_eq),2);

        for k = 1:1:length(r_eq)
            if real(r_eq(k)) > 0 && imag(r_eq(k)) > 0
                bits_double(k,:) = [1, 1];
            elseif real(r_eq(k)) < 0 && imag(r_eq(k)) > 0
                bits_double(k,:) = [-1, 1];
            elseif real(r_eq(k)) > 0 && imag(r_eq(k)) < 0
                bits_double(k,:) = [1, -1];
            elseif real(r_eq(k)) < 0 && imag(r_eq(k)) < 0
                bits_double(k,:) = [-1, -1];
            end
        end

        for l = 1:1:length(bits_double)
            if l == 1
                bits_org = [bits_double(l,:)];
            else
                bits_org = [bits_org, bits_double(l,:)];
            end
        end

        rx = bits_org.';

        rx(rx ~= -1) = 1;
        rx(rx == -1) = 0;

        rx = logical(rx);

        % Calculate the bit error rate (BER).
        % This indicates the relative number of bit errors.
        % Typically this will vary from 0 (no bit errors) to 0.5 (half of all
        % receieved bits are different, which is the number we'd expect if we
        % compare two random bit sequences).
        ber = 1-sum(rx == tx)/length(rx); 
    end

    function txFrame = concat_packages(txPilot,txData)
        % Concatenate two ofdm blocks of equal size into a frame
        txPilot = txPilot(:);
        txData = txData(:);
        if(length(txData) ~= length(txPilot))
            error('Pilot and data are not of the same length!');
        end
        txFrame = [txPilot.', txData.'].';
    end

    function [rxPilot, rxData] = split_frame(rxFrame)
        % Split an ofdm frame into 2 equal ofdm packages
        rxFrame = rxFrame(:);
        if rem(length(rxFrame),2) > 0
            error('Vector z must have an even number of elements'); 
        end
        N = length(rxFrame);
        rxPilot = rxFrame(1:1:N/2);
        rxData = rxFrame(N/2+1:1:end);
    end

    function [rx, evm, ber, symbs] = sim_ofdm_unknown_channel(tx, h, N_cp, snr, sync_err)
        % Simulate OFDM signal transmission/reception over an unknown
        % channel.
        %
        % -----------------------------------------------------------------
        % NOTE: THIS FUNCTION WILL NOT BE SELF-TESTED!
        % It will be up to you to study the output from this function and
        % determine if the results are correct or not.
        % -----------------------------------------------------------------
        %
        % Arguments:
        %   tx          Structure with fields:
        %     .p        Pilot bits to transmit
        %     .d        Data bits to transmit
        %   h           Channel impulse response [-]
        %   N_cp        Cyclic prefix length [samples]
        %   snr         Channel signal/noise ration to apply [dB]
        %   sync_err    Reciever synchronization error [samples]
        % Outputs:
        %   rx          Recieved bits [-]
        %   evm         Error vector magnitude (see below) [-]
        %   ber         Bit error rate (see below) [-]
        %   symbs       Structure containing fields:
        %       .tx         Transmitted symbols
        %       .rx_pe      Recieved symbols, pre-equalization
        %       .rx_e       Recieved symbols, post-equalization
        %
        %
        % This function is similar to the known-channel problem, but with
        % the added complexity of requiring to estimate the channel
        % response. The relevant steps to perform here are:
        %   - Get a sequence of pilot and data bits to transmit
        %   - Convert the pilot and data bits to OFDM symbols
        %   - Create an OFDM block from the OFDM symbols for the pilot and
        %   data
        %   - Add a cyclic prefix to the pilot and data
        %   - Concatenate the pilot and data blocks to create an entire
        %   OFDM frame
        %   - Simulate the transmission and reception over the channel using the
        %   simulate_baseband_channe function.
        %   - Split the recieved message into a recieved pilot and data
        %   segment
        %   - Remove the cyclic prefixes from the recieved messages
        %   - Estimate the channel gain from the pilot block
        %   - Equalize the recieved data symbols by the channel gain
        %   - Convert the equalized symbols back to bits
        %   - Compare the recieved bits/symbols to the transmitted bits/symbols.

		warning('Note that this function is _not_ self-tested. It is up to you to study the output any verify that it is correct! You can remove this warning if you wish.');
		
        % Ensure inputs are column vectors
        tx.d = tx.d(:);
        tx.p = tx.p(:);
        h = h(:);

        tx_alt.d = double(tx.d);

        for i = 1:1:length(tx_alt.d)
            if tx_alt.d(i) == 0
                tx_alt.d(i) = -1;
            else
                tx_alt.d(i) = 1;
            end
        end

        if rem(length(tx_alt.d),2) == 1
            error('bits must be of even length');
        end

        tx_alt.p = double(tx.p);

        for i = 1:1:length(tx_alt.p)
            if tx_alt.p(i) == 0
                tx_alt.p(i) = -1;
            else
                tx_alt.p(i) = 1;
            end
        end

        if rem(length(tx_alt.p),2) == 1
            error('bits must be of even length');
        end
        
        % Convert bits to QPSK symbols
        for k = 1:1:length(tx_alt.d)/2
            x.d(k) = sqrt(1/2)*(tx_alt.d(2*k-1)+1i*tx_alt.d(2*k));
        end

        x.d = x.d.';

        for k = 1:1:length(tx_alt.p)/2
            x.p(k) = sqrt(1/2)*(tx_alt.p(2*k-1)+1i*tx_alt.p(2*k));
        end

        x.p = x.p.';

        symbs.tx = x.d;   % Store transmitted data symbols for later

        % Number of symbols in message
        N = length(x.d);
        if length(x.d) ~= length(x.p)
           error('Pilot and data messages must be of equal length'); 
        end

        % Create OFDM time-domain block using IDFT
        for n = 1:1:N
            for k = 1:1:N
                if k == 1
                    z.d(n) = (1/N).*x.d(k).*exp(1i*2*pi*(k-1)*(n-1)/N);
                else
                    z.d(n) = z.d(n) + (1/N).*x.d(k).*exp(1i*2*pi*(k-1)*(n-1)/N);
                end
            end
        end

        z.d = z.d.';

        for n = 1:1:N
            for k = 1:1:N
                if k == 1
                    z.p(n) = (1/N).*x.p(k).*exp(1i*2*pi*(k-1)*(n-1)/N);
                else
                    z.p(n) = z.p(n) + (1/N).*x.p(k).*exp(1i*2*pi*(k-1)*(n-1)/N);
                end
            end
        end

        z.p = z.p.';

        % Add cyclic prefix to create OFDM package
        zcp.d = [z.d(end-N_cp+1:1:end).', z.d.'].';
        zcp.p = [z.p(end-N_cp+1:1:end).', z.p.'].';
        
        % Concatenate the messages
        tx_frame = [zcp.p.', zcp.d.'].';

        % Send package over channel
        rx_frame = simulate_baseband_channel(tx_frame, h, snr, sync_err);
        % As before, only keep the first samples
        rx_frame = rx_frame(1:2*(N+N_cp));
        
        % Split frame into packages
        ycp = struct();
        ycp.d = rx_frame(length(rx_frame)/2+1:1:end);
        ycp.p = rx_frame(1:1:length(rx_frame)/2);

        % Remove cyclic prefix
        y.d = ycp.d(N_cp+1:1:end);
        y.p = ycp.p(N_cp+1:1:end);

        % Convert to frequency domain using DFT
        for k = 1:1:N
            for n = 1:1:N
                if n == 1
                    r.d(k) = y.d(n).*exp(-1i*2*pi*(k-1)*(n-1)/N);
                else
                    r.d(k) = r.d(k) + y.d(n).*exp(-1i*2*pi*(k-1)*(n-1)/N);
                end
            end
        end

        r.d = r.d.';

        for k = 1:1:N
            for n = 1:1:N
                if n == 1
                    r.p(k) = y.p(n).*exp(-1i*2*pi*(k-1)*(n-1)/N);
                else
                    r.p(k) = r.p(k) + y.p(n).*exp(-1i*2*pi*(k-1)*(n-1)/N);
                end
            end
        end

        r.p = r.p.';

        symbs.rx_pe = r.d; % Store symbols for later
        
        % Esimate channel
        H = r.p./x.p;

        % Remove effect of channel on the data package by equalization.
        r_eq = r.d./H;

        symbs.rx_e = r_eq; %Store symbols for later

        % Calculate the quality of the received symbols.
        % The error vector magnitude (EVM) is one useful metric.
        evm = norm(x.d - r_eq)/sqrt(N);

        % Convert the recieved symsbols to bits
        rx = false(2*length(r_eq),1);

        bits_double = zeros(length(r_eq),2);

        for k = 1:1:length(r_eq)
            if real(r_eq(k)) > 0 && imag(r_eq(k)) > 0
                bits_double(k,:) = [1, 1];
            elseif real(r_eq(k)) < 0 && imag(r_eq(k)) > 0
                bits_double(k,:) = [-1, 1];
            elseif real(r_eq(k)) > 0 && imag(r_eq(k)) < 0
                bits_double(k,:) = [1, -1];
            elseif real(r_eq(k)) < 0 && imag(r_eq(k)) < 0
                bits_double(k,:) = [-1, -1];
            end
        end

        for l = 1:1:length(bits_double)
            if l == 1
                bits_org = [bits_double(l,:)];
            else
                bits_org = [bits_org, bits_double(l,:)];
            end
        end

        rx = bits_org.';

        rx(rx ~= -1) = 1;
        rx(rx == -1) = 0;

        rx = logical(rx);

        % Calculate the bit error rate (BER).
        % This indicates the relative number of bit errors.
        % Typically this will vary from 0 (no bit errors) to 0.5 (half of all
        % receieved bits are different, which is the number we'd expect if we
        % compare two random bit sequences).
        ber = 1-sum(rx == tx.d)/length(rx); 
    end

    function z = frame_interpolate(x,L,hlp)
        % Interpolate (upsample) a signal x by factor L, with an optionally
        % configurable lowpass filter.
        % Arguments:
        %   x   Signal to interpolate, length N
        %   L   Upsampling factor
        %   hlp FIR filter coefficents for lowpass filter, length Nh
        %       If not supplied, a default filter will be used with length
        %       62.
        % Returns:
        %   z   Interpolated signal of length N*L + Nh-1
        %
        
        if nargin < 3       % Default filter design
            SBscale = 1.7;  % Factor for stop band position
            Nfir = 61;      % The filter length if Nfir + 1
            hlp = firpm(Nfir, [0 1/L 1/L*SBscale 1], [1 1 0 0]);
        end
        
        % Make x, hlp column vectors
        x = x(:);
        hlp = hlp(:);
        
        % Get the length of the input signal
        N = length(x);
        
        % Preallocate vector for upsampled, unfiltered, signal
        zup = zeros((N)*L,1);
        
        % Upsample by a factor L, i.e. insert L-1 zeros after each original
        % sample
        for l = 1:1:length(zup)
            if l == 1
                zup(l,:) = x(l,:);
            elseif mod(l, L) == 1
                zup(l,:) = x((l-1)/L+1,:);
            elseif mod(l, L) ~= 1
                zup(l,:) = 0;
            end
        end
        
        % Apply the LP filter to the upsampled (unfiltered) signal.
        z = conv(hlp, zup);
    end

    function z = frame_decimate(x,L,hlp)
        % Decimate (downsample) a signal x by factor L, with an optionally
        % configurable lowpass filter.
        % Arguments:
        %   x   Signal to decimate, length N
        %   L   Downsampling factor
        %   hlp FIR filter coefficents for lowpass filter, length Nh
        %       If not supplied, a default filter will be used with length
        %       61.
        % Returns:
        %   z   Interpolated signal of length N*L + Nh-1
        
        if nargin < 3       % Default filter design
            SBscale = 1.7;  % Factor for stop band position
            Nfir = 61;      % The filter length if Nfir + 1
            hlp = firpm(Nfir, [0 1/L 1/L*SBscale 1], [1 1 0 0]);
        end
        
        % Make x, hlp column vectors
        x = x(:);
        hlp = hlp(:);
        
        % Apply the lowpass filter to avoid aliasing when decimating
        xf = conv(hlp, x);
        
        % Downsample by keeping samples [1, 1+L, 1+2*L, ...]
        for l = 1:1:length(xf)
            if l == 1
                z(l,:) = xf(l,:);
            elseif mod(l, L) == 1
                z((l-1)/L+1,:) = xf(l,:);
            end
        end
    end

    function z = frame_modulate(x, theta)
       % Modulates a signal of length N with a modulation frequency theta.
       % Arguments:
       %    x       Signal to modulate of length N
       %    theta   Normalized modulation frequency
       % Outputs:
       %    z       Modulated signal
       
       % Make x a column vector
       x = x(:);
       
       N = length(x);
       
       % Generate vector of sample indices
       n = (0:N-1);
       n = n(:);
       
       % Modulate x by multiplying the samples with the complex exponential
       % exp(i * 2 * pi * theta * n)
       z = x.*exp(1i*2*pi*theta*n);
    end

    function [rx, evm, ber, symbs] = sim_ofdm_audio_channel(tx, N_cp, snr, sync_err, f_s, f_c, L)
        % Simulate modulated OFDM signal transmission/reception over an
        % audio channel. This fairly accurately simulates the physical
        % channel of audio between a loudspeaker and a microphone.
        %
        % -----------------------------------------------------------------
        % NOTE: THIS FUNCTION WILL NOT BE SELF-TESTED!
        % It will be up to you to study the output from this function and
        % determine if the results are correct or not.
        % -----------------------------------------------------------------
        %
        % Arguments:
        %   tx          Structure with fields:
        %     .p        Pilot bits to transmit
        %     .d        Data bits to transmit
        %   N_cp        Cyclic prefix length [samples]
        %   snr         Channel signal/noise ration to apply [dB]
        %   f_s         The up-sampled sampling frequency [Hz]
        %   f_c         The modulation carrier frequency [Hz]
        %   L           The upsampling/downsampling factor [-]
        % Outputs:
        %   rx          Recieved bits [-]
        %   evm         Error vector magnitude (see below) [-]
        %   ber         Bit error rate (see below) [-]
        %   symbs       Structure containing fields:
        %       .tx         Transmitted symbols
        %       .rx_pe      Recieved symbols, pre-equalization
        %       .rx_e       Recieved symbols, post-equalization
        %
        %
        % This function is similar to the unknown-channel problem, but with
        % the added complexity of requiring to interpolate and modulate the
        % signal before transmission, followed by demodulation and
        % decimation on reception. The relevant steps to perform here are:
        %   - Get a sequence of pilot and data bits to transmit
        %   - Convert the pilot and data bits to OFDM symbols
        %   - Create an OFDM block from the OFDM symbols for the pilot and
        %   data
        %   - Add a cyclic prefix to the pilot and data
        %   - Concatenate the pilot and data blocks to create an entire
        %   OFDM frame
        %   - Interpolate the signal to a higher sample-rate
        %   - Modulate the signal, thereby moving it from the base-band to
        %   being centered about the modulation frequency.
        %   - Simulate the transmission and reception over the channel using the
        %   simulate_baseband_channe function.
        %   - Demodulate the signal, moving the recieved signal back to the
        %   base-band
        %   - Decimate the signal, reducing the sample-rate back to the
        %   original rate.
        %   - Split the recieved message into a recieved pilot and data
        %   segment
        %   - Remove the cyclic prefixes from the recieved messages
        %   - Estimate the channel gain from the pilot block
        %   - Equalize the recieved data symbols by the channel gain
        %   - Convert the equalized symbols back to bits
        %   - Compare the recieved bits/symbols to the transmitted bits/symbols.

		warning('Note that this function is _not_ self-tested. It is up to you to study the output any verify that it is correct! You can remove this warning if you wish.');
		
        % Ensure input is a column vector
        tx.d = tx.d(:);
        tx.p = tx.p(:);
        
        tx_alt.d = double(tx.d);

        for i = 1:1:length(tx_alt.d)
            if tx_alt.d(i) == 0
                tx_alt.d(i) = -1;
            else
                tx_alt.d(i) = 1;
            end
        end

        if rem(length(tx_alt.d),2) == 1
            error('bits must be of even length');
        end

        tx_alt.p = double(tx.p);

        for i = 1:1:length(tx_alt.p)
            if tx_alt.p(i) == 0
                tx_alt.p(i) = -1;
            else
                tx_alt.p(i) = 1;
            end
        end

        if rem(length(tx_alt.p),2) == 1
            error('bits must be of even length');
        end
        
        % Convert bits to QPSK symbols
        for k = 1:1:length(tx_alt.d)/2
            x.d(k) = sqrt(1/2)*(tx_alt.d(2*k-1)+1i*tx_alt.d(2*k));
        end

        x.d = x.d.';

        for k = 1:1:length(tx_alt.p)/2
            x.p(k) = sqrt(1/2)*(tx_alt.p(2*k-1)+1i*tx_alt.p(2*k));
        end

        x.p = x.p.';

        symbs.tx = x.d;   % Store transmitted data symbols for later

        % Number of symbols in message
        N = length(x.d);
        if length(x.d) ~= length(x.p)
           error('Pilot and data messages must be of equal length'); 
        end

        % Create OFDM time-domain block using IDFT
        for n = 1:1:N
            for k = 1:1:N
                if k == 1
                    z.d(n) = (1/N).*x.d(k).*exp(1i*2*pi*(k-1)*(n-1)/N);
                else
                    z.d(n) = z.d(n) + (1/N).*x.d(k).*exp(1i*2*pi*(k-1)*(n-1)/N);
                end
            end
        end

        z.d = z.d.';

        for n = 1:1:N
            for k = 1:1:N
                if k == 1
                    z.p(n) = (1/N).*x.p(k).*exp(1i*2*pi*(k-1)*(n-1)/N);
                else
                    z.p(n) = z.p(n) + (1/N).*x.p(k).*exp(1i*2*pi*(k-1)*(n-1)/N);
                end
            end
        end

        z.p = z.p.';

        % Add cyclic prefix to create OFDM package
        zcp.d = [z.d(end-N_cp+1:1:end).', z.d.'].';
        zcp.p = [z.p(end-N_cp+1:1:end).', z.p.'].';
        
        % Concatenate the messages
        tx_frame = [zcp.p.', zcp.d.'].';
        
        % Increase the sample rate by interpolation
        SBscale = 1.7;
        Nfir = 61;
        hlp = firpm(Nfir, [0 1/L 1/L*SBscale 1], [1 1 0 0]);
                
        hlp = hlp(:);
        
        N = length(tx_frame);
        
        tx_frame_up = zeros((N)*L,1);

        for l = 1:1:length(tx_frame_up)
            if l == 1
                tx_frame_up(l,:) = tx_frame(l,:);
            elseif mod(l, L) == 1
                tx_frame_up(l,:) = tx_frame((l-1)/L+1,:);
            elseif mod(l, L) ~= 1
                tx_frame_up(l,:) = 0;
            end
        end
        
        tx_frame_us = conv(hlp, tx_frame_up);
           
        % Modulate the upsampled signal
        N = length(tx_frame_us);
       
        n = (0:N-1);
        n = n(:);
       
        tx_frame_mod = tx_frame_us.*exp(1i*2*pi*n*(f_c/f_s));
        
        % Discard the imaginary part of the signal for transmission over a
        % scalar channel (simulation of audio over air)
        tx_frame_final = real(tx_frame_mod);

        [PSD_Tx, freq_Tx] = pwelch(tx_frame_mod, 500, 300, 500, f_s);
        figure(4);
        plot(freq_Tx, 10*log10(PSD_Tx));
        xlabel('Frequency [Hz]');
        ylabel('PSD [dB/Hz]');
        grid on

        % Send package over channel
        [rx_frame_raw, rx_idx] = simulate_audio_channel(tx_frame_final, f_s, snr, sync_err);
        
        % Discard data before/after package
        rx_frame_raw = rx_frame_raw(rx_idx:rx_idx + length(tx_frame_final));
        
        [PSD_Rx, freq_Rx] = pwelch(rx_frame_raw, 500, 300, 500, f_s);
        figure(5);
        plot(freq_Tx, 10*log10(PSD_Tx));
        hold on
        plot(freq_Rx, 10*log10(PSD_Rx));
        xlabel('Frequency [Hz]');
        ylabel('PSD [dB/Hz]');
        grid on
        legend({'Transmitter', 'Receiver'}, 'Location', 'NorthEast');

        % Demodulate to bring the signal back to the baseband
        N = length(rx_frame_raw);
       
        n = (0:N-1);
        n = n(:);

        rx_frame_us = rx_frame_raw.*exp(-1i*2*pi*n*(f_c/f_s));
        
        % Decimate the signal to bring the sample rate back to the original
        rx_frame_us_filt = conv(hlp, rx_frame_us);
        
        % Downsample by keeping samples [1, 1+L, 1+2*L, ...]
        for l = 1:1:length(rx_frame_us_filt)
            if l == 1
                rx_frame(l,:) = rx_frame_us_filt(l,:);
            elseif mod(l, L) == 1
                rx_frame((l-1)/L+1,:) = rx_frame_us_filt(l,:);
            end
        end

        N = length(x.d);
        
        % Discard samples beyond OFDM frame
        rx_frame = rx_frame(1:2*(N+N_cp));
        
        % Split frame into packages
        ycp = struct();
        ycp.d = rx_frame(length(rx_frame)/2+1:1:end);
        ycp.p = rx_frame(1:1:length(rx_frame)/2);

        % Remove cyclic prefix
        y.d = ycp.d(N_cp+1:1:end);
        y.p = ycp.p(N_cp+1:1:end);

        % Convert to frequency domain using DFT
        for k = 1:1:N
            for n = 1:1:N
                if n == 1
                    r.d(k) = y.d(n).*exp(-1i*2*pi*(k-1)*(n-1)/N);
                else
                    r.d(k) = r.d(k) + y.d(n).*exp(-1i*2*pi*(k-1)*(n-1)/N);
                end
            end
        end

        r.d = r.d.';

        for k = 1:1:N
            for n = 1:1:N
                if n == 1
                    r.p(k) = y.p(n).*exp(-1i*2*pi*(k-1)*(n-1)/N);
                else
                    r.p(k) = r.p(k) + y.p(n).*exp(-1i*2*pi*(k-1)*(n-1)/N);
                end
            end
        end

        r.p = r.p.';

        symbs.rx_pe = r.d; % Store symbols for later
        
        % Esimate channel
        H = r.p./x.p;

        % Remove effect of channel on the data package by equalization.
        r_eq = r.d./H;

        symbs.rx_e = r_eq; %Store symbols for later

        % Calculate the quality of the received symbols.
        % The error vector magnitude (EVM) is one useful metric.
        evm = norm(x.d - r_eq)/sqrt(N);

        % Convert the recieved symsbols to bits
        rx = false(2*length(r_eq),1);

        bits_double = zeros(length(r_eq),2);

        for k = 1:1:length(r_eq)
            if real(r_eq(k)) > 0 && imag(r_eq(k)) > 0
                bits_double(k,:) = [1, 1];
            elseif real(r_eq(k)) < 0 && imag(r_eq(k)) > 0
                bits_double(k,:) = [-1, 1];
            elseif real(r_eq(k)) > 0 && imag(r_eq(k)) < 0
                bits_double(k,:) = [1, -1];
            elseif real(r_eq(k)) < 0 && imag(r_eq(k)) < 0
                bits_double(k,:) = [-1, -1];
            end
        end

        for l = 1:1:length(bits_double)
            if l == 1
                bits_org = [bits_double(l,:)];
            else
                bits_org = [bits_org, bits_double(l,:)];
            end
        end

        rx = bits_org.';

        rx(rx ~= -1) = 1;
        rx(rx == -1) = 0;

        rx = logical(rx);

        % Calculate the bit error rate (BER).
        % This indicates the relative number of bit errors.
        % Typically this will vary from 0 (no bit errors) to 0.5 (half of all
        % receieved bits are different, which is the number we'd expect if we
        % compare two random bit sequences).
        ber = 1-sum(rx == tx.d)/length(rx); 
    end



% Generate structure with handles to functions
funs.add_cyclic_prefix = @add_cyclic_prefix;
funs.remove_cyclic_prefix = @remove_cyclic_prefix;
funs.bits2qpsk = @bits2qpsk;
funs.qpsk2bits = @qpsk2bits;
funs.sim_ofdm_known_channel = @sim_ofdm_known_channel;
funs.concat_packages = @concat_packages;
funs.split_frame = @split_frame;
funs.sim_ofdm_unknown_channel = @sim_ofdm_unknown_channel;

funs.frame_interpolate = @frame_interpolate;
funs.frame_decimate = @frame_decimate;
funs.frame_modulate = @frame_modulate;
funs.sim_ofdm_audio_channel = @sim_ofdm_audio_channel;


% This file will return a structure with handles to the functions you have
% implemented. You can call them if you wish, for example:
% funs = student_sols();
% some_output = funs.some_function(some_input);
end